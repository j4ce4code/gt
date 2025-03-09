gt() {
  local locations_file="${HOME}/.gt_locations"

  # Display help and list all mappings if --help is passed.
  if [ "$1" = "--help" ]; then
    if [ -f "$locations_file" ]; then
      echo "Available mappings from $locations_file:"
      # Ignore comments (lines starting with #) and blank lines.
      grep -Ev '^[[:space:]]*#|^[[:space:]]*$' "$locations_file" | while IFS=':' read -r key path; do
        # Trim whitespace from key and path
        key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        path=$(echo "$path" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        echo "  $key -> $path"
      done
    else
      echo "Locations file not found: $locations_file"
    fi
    return 0
  fi

  # Check that a key is provided.
  if [ $# -eq 0 ]; then
    echo "Usage: gt <key>"
    echo "Run 'gt --help' to see available mappings."
    return 1
  fi

  local key="$1"

  if [ ! -f "$locations_file" ]; then
    echo "Locations file not found: $locations_file"
    return 1
  fi

  # Find the line that matches the key.
  local line
  line=$(grep -E "^[[:space:]]*${key}[[:space:]]*:" "$locations_file")
  if [ -z "$line" ]; then
    echo "Key not found: $key"
    return 1
  fi

  # Extract the path by removing everything before the colon and trimming spaces.
  local path
  path=$(echo "$line" | cut -d ':' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  if [ -z "$path" ]; then
    echo "No path specified for key: $key"
    return 1
  fi

  cd "$path" || {
    echo "Failed to change directory to: $path"
    return 1
  }
}
