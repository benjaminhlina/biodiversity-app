#!/bin/sh
set -e

# Write env vars to shiny user's Renviron

# Write env vars # cat <<EOF > /home/shiny/.Renviron
cat > /srv/shiny-server/gbif-app/.Renviron <<EOF

EOF

#chmod 600 /home/shiny/.Renviron
chown shiny:shiny /srv/shiny-server/gbif-app/.Renviron
chmod 600 /srv/shiny-server/gbif-app/.Renviron

echo "--- Renviron written ---"
# Start Shiny Server
exec shiny-server
