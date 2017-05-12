echo "--- a/setup.py" > taiga-back-setup-py.patch
echo "+++ b/setup.py" >> taiga-back-setup-py.patch
echo "@@ -0,0 +1,$(cat taiga-back-setup.py | wc -l) @@" >> taiga-back-setup-py.patch
cat taiga-back-setup.py| sed 's/^/+/g' >> taiga-back-setup-py.patch
