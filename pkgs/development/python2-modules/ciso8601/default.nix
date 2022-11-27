{ ciso8601, unittest2 }:

ciso8601.overridePythonAttrs (oldAttrs: {
  checkInputs = oldAttrs.checkInputs ++ [
    unittest2
  ];
})
