export PATH=/opt/homebrew/bin:${PATH}

if [ "${ENABLE_PREVIEWS}" = "YES" ]; then
  echo "Previews enabled, quitting to prevent 'preview paused'."
  exit 0;
fi

if mint list | grep -q 'R.swift'; then
  mint run R.swift rswift generate "$PROJECT_DIR/$PROJECT_NAME/Resources/R.generated.swift"
else
  echo "error: R.swift not installed; run 'mint bootstrap' to install"
  return -1
fi
