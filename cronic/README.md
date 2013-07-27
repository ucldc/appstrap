# Utilities for long running jobs

### `~/appstrap/cronic/atnow` command
Wrapper for the unix `at` command.  Pass a command as a parameter, it will be passed to `cronic` and run as-if-by-cron.  

```bash
~/appstrap/cronic/atnow /path/to/long_running_job
```

If the command has any output or does not have a `0` exit code -- then an email will be generated from cron when the command is finished.

### `~/appstrap/cronic/cronic` command
[Cronic](http://habilis.net/cronic/) is a shell script written by Chuck Houpt to help control the most annoying feature of cron: unwanted emailed output, or "cram" (cron spam).

Ususally, you won't run this directly, but from a cron/at job.

```crontab
0 1 * * * /path/to/appstrap/cronic/cronic /path/to/long_running_job
```

### `~/appstrap/cronic/spinner` command
Prints a spinning pattern on the screen to keep a terminal connection from timing out.

### `~/appstrap/cronic/log` directory
STDOUT and STDERR from commands run with `atnow`/`cronic`
