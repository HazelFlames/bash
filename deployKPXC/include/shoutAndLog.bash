shoutAndLog() {
  echo "$1"
  echo "$(date +%Y/%-m/%-d\ %T): $1" >> "$LOG"
  sleep 0.3s
}
