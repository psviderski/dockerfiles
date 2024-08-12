#!/bin/sh
set -eu

CONFIG_DIR=/config
PLEXCONNECT_DIR=/opt/plexconnect
: "${PLEXCONNECT_HOSTTOINTERCEPT:=trailers.apple.com}"

# Generate SSL certificate if doesn't exist in the config directory.
if [ ! -f "${CONFIG_DIR}/trailers.cer" ]; then
  echo "Generating SSL certificate"
  (
    # Run in a subshell to temporary change the working directory.
    cd ${CONFIG_DIR}
    openssl req -new -nodes -newkey rsa:2048 -out trailers.pem -keyout trailers.key -x509 -days 7300 -subj "/C=US/CN=${PLEXCONNECT_HOSTTOINTERCEPT}"
    openssl x509 -in trailers.pem -outform der -out trailers.cer
    cat trailers.key >> trailers.pem
    rm trailers.key
  )
fi
# Copy SSL certificate files from the config directory to plexconnect assets.
cp ${CONFIG_DIR}/trailers.* "${PLEXCONNECT_DIR}/assets/certificates/"

# Create Settings.cfg from ENV vars.
echo "[PlexConnect]" > "${PLEXCONNECT_DIR}/Settings.cfg"
env | grep '^PLEXCONNECT_' | sed -E -e 's/^PLEXCONNECT_//' -e 's/(.*)=/\L\1 = /' >> "${PLEXCONNECT_DIR}/Settings.cfg"

# Link ATVSettings.cfg from the config directory to make any changes persistent.
ln -sf "${CONFIG_DIR}/ATVSettings.cfg" "${PLEXCONNECT_DIR}/"

exec "$@"
