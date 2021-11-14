import setuptools

setuptools.setup(
    name="@pname@",
    version="@version@",
    package_dir={"": "."},
    packages=setuptools.find_packages(where="."),
    python_requires=">=3.6",
    scripts=@scripts@
)
