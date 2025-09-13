# Integration Tests

These tests are supposed to check the individual steps of the fetcher and the builder
1. (Lockfile transformer) deno lockfile to common lockfile format
2. (fetcher) common lockfile format, used to fetch packages, and produces common lockfile format with filled in paths
3. (file transformer) common lockfile format with filled in paths and fetched packages at those paths
are transformed to the directory structure that deno can consume

## Design Constrains

The tests were consciously not written as unit test,
tightly coupled to the language that the individual scripts are written in.

Instead, they are written as integration tests, which
- don't care about the scripts language (other than how they are executed)
- treat the scripts as black boxes
- use the actual file system, and avoid the need for file system abstraction in the scripts.
Those abstractions would create tight coupling to the language again.
- use fixtures (`(input, expected output) pairs`) to check, whether the scripts are doing what they are supposed to
- don't have fixture files directly on disk an commit them to git, instead have them in code and realize them when needed at test runtime

Also, to be fully reproducible, since the tests are written with deno,
and can't use the very deno build helper they try to test (chicken egg problem),
they can't use any external imports.

## Test Design

A test looks roughly like this:

Inputs:
- Array of (virtual) input files
- Array of expected (virtual) output files

Functionality:
- ensure input files are realized on disk
- run the script to be tested and feed it the input files, using CLI args
- (for the fetching step) use a mock server to serve files from the inputs
- read the output files of the script and compare them to the expected outputs
- to make the test output actually useful, it uses a fancy diff package

Outputs:
- Either Success, or Failure with a fancy diff, what files were not as expected
