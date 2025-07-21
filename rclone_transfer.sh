#!/bin/bash

# Description: Sync from Google Drive to local hard drive using rclone
###############################################################################
# RCLONE GOOGLE DRIVE SYNC SCRIPT
#
# Description:
#   This script synchronizes files from a specified cloud folder (Google Drive)
#   to a local directory using `rclone`.
#
#   It uses `caffeinate` to prevent the local machine from sleeping during the sync 
#   process, which is important for long-running transfers.
#
#   The script supports an optional `--dry-run` flag, which simulates the sync 
#   without transferring or deleting any files. Useful for previewing changes.
#
#   A detailed log is created for each sync session with a timestamped filename.
#
# Usage:
#   ./sync_gdrive.sh             # Run the sync normally
#   ./sync_gdrive.sh --dry-run   # Preview what would happen without making changes
#
###############################################################################


# set variables
SRC="googledrive:/Baubec_lab/other_to_be_organized"
DEST="/Volumes/Seagate_5tb/test"
LOG_DIR="/Users/daviderecchia/Downloads/rclone_logs"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/rclone_backup_hpc_uu_$TIMESTAMP.log"

# optional dry run
DRYRUN=false

# parse optional --dry-run argument
if [[ "$1" == "--dry-run" ]]; then
  DRYRUN=true
fi

# build rclone options in an array
RCLONE_OPTS=(
  sync
  "$SRC"
  "$DEST"
  --progress
  --checksum
  --create-empty-src-dirs
  --log-file="$LOG_FILE"
  --log-level INFO
  --transfers 16 \
  --tpslimit 10 \
  --drive-chunk-size 64M \
  --multi-thread-streams 4 \
)

if $DRYRUN; then
  RCLONE_OPTS+=(--dry-run)
  echo "Running in DRY-RUN mode — no files will be copied or deleted"
fi

echo "Starting sync from $SRC to $DEST"
echo "Log file: $LOG_FILE"

# prevent sleep using caffeinate and run rclone command
caffeinate -dims rclone "${RCLONE_OPTS[@]}"

echo "Sync complete"

