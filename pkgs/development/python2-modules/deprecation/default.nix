{ deprecation, unittest2 }:

deprecation.overridePythonAttrs (oldAttrs: {
  checkInputs = oldAttrs.checkInputs ++ [
    unittest2
  ];
})
