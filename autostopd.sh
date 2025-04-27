# Stop containers from restarting automatically
for cid in $(docker ps -q); do
  docker update --restart=no "$cid"
done

# Self-destruct!
rm -- "$0"
