#! @shell@

# Print a greeting.
echo
echo "<<< NixOS Stage 1 >>>"
echo

# Set the PATH.
export PATH=/empty
for i in @path@; do
    PATH=$PATH:$i/bin
done

# Create device nodes in /dev.
source @makeDevices@

# Start an interactive shell.
exec @shell@
