expectFilePresent () {
  if [ -f "$1" ]; then
    echo "Test passed: file is present - $1"
  else
    echo "Test failed: file is absent - $1"
    exit 1
  fi
}

expectFileOrDirAbsent () {
  if [ ! -e "$1" ];
  then
    echo "Test passed: file or dir is absent - $1"
  else
    echo "Test failed: file or dir is present - $1"
    exit 1
  fi
}

expectEqual () {
  if [ "$1" == "$2" ];
  then
    echo "Test passed: output is equal to expected_output"
  else
    echo "Test failed: output is not equal to expected_output:"
    echo "  output - $1"
    echo "  expected_output - $2"
    exit 1
  fi
}
