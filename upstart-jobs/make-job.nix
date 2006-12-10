{runCommand}: job:

runCommand job.name {inherit (job) job;}
  "ensureDir $out/etc/event.d; echo \"$job\" > $out/etc/event.d/$name"
