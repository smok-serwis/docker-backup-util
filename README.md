# Docker backup utility


## Requirements

You need to set following envs:

* **DOCKER_HOST** - Docker endpoint. Required only if _start_ and _stop_ are used.

Volumes needed:

* **/volumes** - normally _/var/lib/docker/volume_, readonly.
* **/root** - normally _/_, readonly. Required only if _archive_ is used.
* **/backups** - directory to put your backups to. Writable
* **/profiles** - backup profile definitions. If you want to build
  on this image, you can set the env _PROFILE_DIRECTORY_ to some other directory
  and put profiles there.

You should run the container with the command matching the backup profile name.
If backup profile does not exist, return code 1 will be raised,
unless env _RC0_IF_NOT_ARGUMENT_ is set. In this case it will be 0.

Return code 2 is returned if requested profile did not exist.

You can set env _RATE_LIMIT_ to a maximum speed of compression. Default is **100m**,
which means 100 MB/s.

## Backup profiles

A backup profile is a text file that uses simple commands to archive things.

* _backup_ X - archive a Docker volume called X, into X.tar.gz
* _start_ X - start a Docker container with given name
* _stop_ X - stop a Docker container with given name
* _archive_ X Y - archive an arbitrary directory on filesystem, expressed
  with a absolute path X, and save it as Y.tar.gz.

### Example of a backup profile

Our daily backup is the PostgreSQL database plus system logs. We do it
with a profile **daily**:

```
stop dms-postgres
backup dms-postgres
start dms-postgres

archive /var/log syslogs
```

They are executed via bash's _source_, so beware of code injections!
