#! @shell@

# Print a greeting.
cat <<EOF

<<< NixOS Stage 1 >>>

EOF

# Set the PATH.
export PATH=/empty
for i in @path@; do
    PATH=$PATH:$i/bin
done

# Start an interactive shell.
exec @shell@
