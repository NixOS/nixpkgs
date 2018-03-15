source @withX@/nix-support/setup-hook

@ratpoison@/bin/ratpoison &

while ! ( @ratpoison@/bin/ratpoison -c windows & sleep 0.5; kill %1; ) | grep .; do :; done

waitWindow () {
  name="$1"; shift       
  while ! ratpoison -c "windows $@" | grep -iE "$name"; do
    echo still waiting for "$name"
    sleep 1;
  done
}
