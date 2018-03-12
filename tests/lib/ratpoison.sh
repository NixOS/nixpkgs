source @withX@/nix-support/setup-hook

@ratpoison@/bin/ratpoison &

while ! ( @ratpoison@/bin/ratpoison -c windows & sleep 0.5; kill %1; ) | grep .; do :; done
