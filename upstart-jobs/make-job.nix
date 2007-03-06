{runCommand}: job:

(
  runCommand job.name {inherit (job) job;}
    "ensureDir $out/etc/event.d; echo \"$job\" > $out/etc/event.d/$name"
)

//

# Allow jobs to declare extra packages that should be added to the
# system path.
{
  extraPath = if job ? extraPath then job.extraPath else [];
}