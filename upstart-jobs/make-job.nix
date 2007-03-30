{runCommand}: job:

(
  runCommand job.name {inherit (job) job;}
    "ensureDir $out/etc/event.d; echo \"$job\" > $out/etc/event.d/$name"
)

//

# Allow jobs to declare extra packages that should be added to the
# system path, as well as extra files that should be added to /etc.
{
  extraPath = if job ? extraPath then job.extraPath else [];
  extraEtc = if job ? extraEtc then job.extraEtc else [];
}
