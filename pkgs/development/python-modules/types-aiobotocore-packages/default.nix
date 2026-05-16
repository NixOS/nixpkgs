{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage (finalAttrs: {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName finalAttrs.oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    });
in
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "3.2.1"
      "sha256-LKwACFaSId1ugUoNLWd4lwZ2S2DvuynJSgI/03M4T70=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "3.2.1"
      "sha256-0Q/6ob9RYyfFUt5U06u2bGGloqwQBP51nNX/yX5oRC8=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "3.2.1"
      "sha256-Ghyi7RC7JaLidz3qpwx147Bv/Vzc7SQ5F3gfllPEXPE=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "3.2.1"
      "sha256-PcL2JpFkpCr2Z96StwGhvKsxhN7NlCiCvhn/VDOKmhM=";

  types-aiobotocore-aiops =
    buildTypesAiobotocorePackage "aiops" "3.2.1"
      "sha256-p3OVeIsmnvNreE4Mq5Ha+VuJrg2aAtXX/aSAXuXnxZg=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "3.2.1"
      "sha256-dzwGc02pA6l5FPl/ATgRtFLE5toJs8q7XpqsmJhBKxw=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "3.2.1"
      "sha256-JhsaPzN8lK7cE2sg7BcKonmPikmbzhuJdIRCa5yD1mQ=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "3.2.1"
      "sha256-+oiBhyVCi4D3G69V5ZcD1B5OgIIr/BJjMZIowI4tzaw=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "3.2.1"
      "sha256-s/lgpeXOo3CxttRWC8q3DXSlwqj0vwBV89Vv4rGPXDo=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "3.2.1"
      "sha256-hcKVgCEKiEGvL52djhowKM9hV8ykE9kxQxWErPaZh94=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "3.2.1"
      "sha256-LUGYEjX2KyzuDvjrPGv7L1ATURWfSlRXu0nyqITGJac=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "3.2.1"
      "sha256-RAJdxP2chNPBZ2hdPuoUBlxI1z52ZOdCq7AIESyUDuo=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "3.2.1"
      "sha256-vQ6zx6AyAGY2oVl8b60FEkkTFYvmpTJRglKYrHxOUiQ=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "3.2.1"
      "sha256-qeZ4hs83Cyt5rCWAePBnb5f8RiuYtB2lNnJNmBX2Pps=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "3.2.1"
      "sha256-73jEwdib0lzRHo1x/8CBOTDK/KNXxZaebVVkLGTCnBs=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "3.2.1"
      "sha256-oL9q0HzMDQdigF8xvnkzfTDfNiMg8zzI+9L8kZN1v/E=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "3.2.1"
      "sha256-bFOtA9E5XpeBYBsMiqUBwJnb3yWXfJr5NLZcFPWoNfY=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "3.2.1"
      "sha256-NGZfr5AkgB7LcPZMHvC55rWic1rLwNY0Yz3cmCufS7w=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "3.2.1"
      "sha256-VMn2zhIpB0HGvMVFH1WutYHTlJfBFfv5ACr9MXv6oOo=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "3.2.1"
      "sha256-G66axJ0W5W1eepD4RMlFU/MAstsGT8254kp4KZG85Kk=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "3.2.1"
      "sha256-+SlUgPVNfrrW0ltyAwEWRMda3f9efl5BdjoS3rNOE98=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "3.2.1"
      "sha256-8LHrPciJFxj2UzCxVW9H06RKQy1R5R+RR3EUr9ixYv8=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "3.2.1"
      "sha256-y7X8QuIdP27lCV+SNWoBtqMxyY3IrDLgFyzCqCC7Bt8=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "3.2.1"
      "sha256-VOECadrcUyT1hQmoCO4xvNaCTmnOqGpW4HDR38Tz+ok=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "3.2.1"
      "sha256-gpAL7T3aRY6bCpOOqvrbVMZcOI74KsQZZCAv5MbZBNk=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "3.2.1"
      "sha256-nKLtk/Zk53Z/n4Khxnbuw748Smwtmr87Z89DY1v/NJ4=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "3.2.1"
      "sha256-EalhjDTHUU9M1m4wHFVZUFDPqlXG/s3jI8oeGIw6nmg=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "3.2.1"
      "sha256-8Lny3FDj9/GwobfHWYZh/esNrYl3t2qBjdShAVWj8Ds=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "3.2.1"
      "sha256-6KuwDlEsrtmsbSsu4PobKh5JzjVNkyAqZ40eiFcwZfo=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "3.2.1"
      "sha256-4LNTn1/WIORiCYWkCidQtE9nxhu84QKiOXZ2H2Xc8/w=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "3.2.1"
      "sha256-AwTx4Qsvk1ivUjhEcs6hzvNq7FhuLvXvKNkpCyJ9GoA=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "3.2.1"
      "sha256-CnFOydFD9gP8h+uZ/L8O0lp2BkWwoJD02jUMi4aKSKI=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "3.2.1"
      "sha256-PabjRnkDm069mZPwMBqmwAXtUGi+lhDYKmpc1ErlOpo=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "3.2.1"
      "sha256-Y4VnlqF6KaqiUMnurfYdJRc9eGzAjujDAqgTQ/Z2ijc=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "3.2.1"
      "sha256-mV/7pJW8zqgPB0Yv15AwocN32fDLkLZXcL4qmZIVOv8=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "3.2.1"
      "sha256-TvJB0HC9hf3t0aAjTVenfnJ/mG85aYk/fR6XPkcE5CY=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "3.2.1"
      "sha256-zk3kr3Mq7KXAlnEzdEGLMmjWGTGZjfJfUl7xPvcI5M4=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "3.2.1"
      "sha256-9/arE0s3x3RzTpfqsZQb0oyPFr3OUmRWaZYolaWVhEo=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "3.2.1"
      "sha256-OrjJNfpJLLJeyVSY35bxb/uMyYA22/4NteHrozWLvX4=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "3.2.1"
      "sha256-N1FSXhOY9WIELG6X/wwDm3H7FFXkWEUknES5eZCaTX8=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "3.2.1"
      "sha256-f/k4jVNuUhDKQg3x8FEPBJGLRZZ5OoP69kMirKGIk+g=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "3.2.1"
      "sha256-YTjZYOuLLiZgvKqjO9EINXIO2PZGG3hQHHc1TQbGevw=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "3.2.1"
      "sha256-MKy6SsBrAPcALlEcIv53j5YIdf5EHLhK/quPYkTSkmI=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "3.2.1"
      "sha256-o6Yhp6Dr/wihzjMfT3ftJ4BG2R7D+9ZRUZ+1yIFUGvQ=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "3.2.1"
      "sha256-gCoaKyyDB5Zt9jVKT3CFdhB7xcLL+mJu14wGwb/7GMY=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "3.2.1"
      "sha256-HmsRg0NeBv3s6lqPxke/x4Ix+cvx+FLfIkqpeaeCcc0=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "3.2.1"
      "sha256-QjtSWh/rqtX1RJClkc3dAZ56T8PELzBqM7yUyYZxxiw=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "3.2.1"
      "sha256-/3Lg+E1hR1d08Yn7fMQxTu+6TS8Zpd8Tpc8uIOjKm30=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "3.2.1"
      "sha256-qD7aD4XZhl/tCP5TykJ43gArPWFdnAO1bycv6Ft2bzA=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "3.2.1"
      "sha256-cRSylvQOZwTC4he5wBnWAmV3ElXSLfvvF77FafKJO6M=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "3.2.1"
      "sha256-QVn/4DwIJ6xW2VYz3mFfFn8HMNnob409TMndBDvz4Ag=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "3.2.1"
      "sha256-YLnhSCHaA3JN2tN3fdxWoN6FO0xRKAfiA8uMgl3wh9c=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "3.2.1"
      "sha256-UWhjObXhZJpyEwA956zM/RSOsRp3B2XwmIWjTYOKDNM=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "3.2.1"
      "sha256-1UlynfSddXWzzvOeUc33jQw49lp/nk6fE84AfKak2Ng=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "3.2.1"
      "sha256-JjjS7tIBYWaY09Pyac/1+SvPFsJFlSI8P0D5VRTeSuY=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "3.2.1"
      "sha256-2gPSRwcrYaoJ1p6GBnjSJrFHJKbyORD5regRyAlPaNY=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "3.2.1"
      "sha256-2EFD8V4dAYV1yadRguNFuQlOfCzYjtYFHSXVMhjacHA=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "3.2.1"
      "sha256-7ZgutdbK5fdNE/aVlJ9zEaWr6YZO/qmZViCusOFVUy8=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "3.2.1"
      "sha256-ktP+CgtG5pfRI/58Wa5frKgGMKiDR3KarWQkeexjdM0=";

  types-aiobotocore-codeconnections =
    buildTypesAiobotocorePackage "codeconnections" "3.2.1"
      "sha256-AqmRmvw1hmp6jaQcoIsz44s9PRSoNupAi/zC7QYIDz4=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "3.2.1"
      "sha256-Kd1nAzs5wT8VOu8DOJBN0BymN6+WyU22qV9FXLjU660=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "3.2.1"
      "sha256-KMNlx9UaTgpKGlXO0vu6eOXadYA1GqEae8n686/sF2g=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "3.2.1"
      "sha256-RAvYvmCnilENQ4gReRHSlhyPgG+/DPlF8Spa0b3iRb0=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "3.2.1"
      "sha256-FwxO7tTurkldpF1AoPk4RLOdvNprMUcG+/XyBqFBERw=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "3.2.1"
      "sha256-ZOwt3WD/necA4Iw4x6jI9ocZuilf+sZVugjyvLw/WRE=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "3.2.1"
      "sha256-AQVvlojsMjpajtb1J0hvG0YtzAedVz/g13e9pyC9vdU=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "3.2.1"
      "sha256-YrDkhrd+9GpHXpfyQ24RlXQ9bAIUsRMN86JSH79ni/A=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "3.2.1"
      "sha256-2r6pZRq+PjffQwOf92Rb/6CQIliv9aTu9+iW5ro3hvg=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "3.2.1"
      "sha256-SQIfFqmGuB5VUqFQyX9QtNQv5COEpXM33johxXBLJSU=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "3.2.1"
      "sha256-Xr91cu3lmfjfgrO+8x6ppTMAMLo1nhLgpAMcKympeSo=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "3.2.1"
      "sha256-yWxaPnjjTybegCuMTwTdJHSFOJwzanG874PFV9crmqE=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "3.2.1"
      "sha256-qqPVt51S0OvdifLTKkP4fMdkBuyy6H7QSBWe99tJdeo=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "3.2.1"
      "sha256-GuAEwZN/hlMsW2whrKsrPcAKpIr1i9iS1i8Xtn6/AR0=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "3.2.1"
      "sha256-euCAN2Bn1TuzVJw/D8PADzFeFngE5EZXbiqYbYEpFco=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "3.2.1"
      "sha256-LVqDhDopGqTRGIkfohTuwOZjc6dwibC61uw0HqDSzdI=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "3.2.1"
      "sha256-dknYp7bxyQc+DD2fVA7iV9929LSQVuBhrJ0xEOsJk6M=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "3.2.1"
      "sha256-YG90F8LJUwTuCIudQkZAbHiQWlN+9IGo748NE1u0DWw=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "3.2.1"
      "sha256-YXSyU9DTJX3QnyuWn0M/ijeovzDH9EcQWwuuaii8Mo8=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "3.2.1"
      "sha256-8PUmPyV9hg3lJ9Wh3EF4e/RaJ1IvzzBEQ2q0vwfGbM4=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "3.2.1"
      "sha256-S9F+1oAyF7mG2gLfOUtBB5baAYi0QgL4D3hXlKYFOuQ=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "3.2.1"
      "sha256-L49VAhO+ac3fkcfteqKQdX/WN1/rTeyMLOjg6P8BYGM=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "3.2.1"
      "sha256-z3Rx7K6Uwur0Pdr4eYzTpO729FxezR98MhhMZWPy1rk=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "3.2.1"
      "sha256-XfZDzcYLG+zhzS4ydUs2/r9V/WG4HkHJZLXXehwi0Ak=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "3.2.1"
      "sha256-dkY0bvtUVnjXQWo1HTfBnvXYN9+RRkIRqQuovZv1QZ4=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "3.2.1"
      "sha256-kvF6vjubCnYxiptJvZaVezYk9x5m6JwHuCfJ6ojpgrA=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "3.2.1"
      "sha256-UTDvdjpY/urqk5ede6rKo2yUOBWLUlud+u+gaEcVYsI=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "3.2.1"
      "sha256-H2ipRxcJeKOZzxeIFrYBZT1LPrUuP/RoJkanGcXYfbs=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "3.2.1"
      "sha256-sqVBTk8wBvTX3H2IJPCDUoZVLGaqfeUgCLYa2Es0Dy4=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "3.2.1"
      "sha256-6grjSkzkL0YLk7o75WsBfkqhL66BcPw5sZlJLsPjsTU=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "3.2.1"
      "sha256-OJA1GvS+0FoReJOXgdZjRp44aGmW4OrQlnkthWISwCI=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "3.2.1"
      "sha256-MqYoasLY658x1vS9Xe3rXLYmN1q5nvw5B2bRtGtPCcs=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "3.2.1"
      "sha256-+jzYNIVwbC1CvH9tJhYRAKFn8YgSRAZwE4qNg+4p3Mo=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "3.2.1"
      "sha256-j0NlhhEVQtzY/XtmAlHi3cv8DNhrs+wey52YKlneVlA=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "3.2.1"
      "sha256-cbwWa/ByQ84Ag9LYSICpiU5+l4VhGo2kow+prVTWeD0=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "3.2.1"
      "sha256-pxIFr/V/ZpGiYeIG55aWYaojyVejmhOidXe23vR65QM=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "3.2.1"
      "sha256-L+ybxfHUu6lxf/LDgYAiCG6WucEuVAgjGNZVkTQwAZ8=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "3.2.1"
      "sha256-w53fLAoZntOMctG2tXL6ZzIokaNFLSK8LMYHYN+nXYE=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "3.2.1"
      "sha256-fsK23lR6jeitkAG3ROn+uWGRcXyRxDJ3qlrcMsZYPyc=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "3.2.1"
      "sha256-ViDfx7QOIoNMLbMDc5A8WzD1DKTuLpnbvZb+JbCMHtw=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "3.2.1"
      "sha256-87ZAw0XiAIX0+LIH6Hvzk5IEf9LIEwdwhqU4hZnQ8mQ=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "3.2.1"
      "sha256-JPTpNLkxmCA5ffkknL3TsGkkM8SHKc5UOLB5pj4Y52E=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "3.2.1"
      "sha256-AoHnBoD1/5g2EUBOtP5AAr2+rcJDCKFz6JP4aTXfeao=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "3.2.1"
      "sha256-ZFveuk15AR/8501sRhsJmv4BZyerfGjJjTc+fMR2gnA=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "3.2.1"
      "sha256-QIwIDsAC1jVx4B3RZulJ0mHF/ND9bGR2ZrbI8UKTkTs=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "3.2.1"
      "sha256-uojcKxNKY5AlamiO3kSEfX3XedsNFDSeM0qYLnwk8GE=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "3.2.1"
      "sha256-91HfKCI+RSFNZiL6o6C0d/q/LL1ZfXLvN5vDAHBHUZc=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "3.2.1"
      "sha256-aqbG7JRx1y557BN9K2zZNCPTGh4M5sY1Ov+qMealGYQ=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "3.2.1"
      "sha256-E+zl4Z2+DoXtC/dZijqTVqB38YzKwZF8gOVc5f1L/3U=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "3.2.1"
      "sha256-kNOlmDryMv/ddfL8Ef99hbuDEy9IUrJQ65ldbs6mlnU=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "3.2.1"
      "sha256-FIJRZa7ZqAhvNLWblQ4a1f2mvSU2Q/xwW74LbsQIZhk=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "3.2.1"
      "sha256-H6ejZLwIDdIRZJiB6o40wm4ooe0NXrMiQtXJVP3pzYc=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "3.2.1"
      "sha256-nHP8BmUYum/rh5sr1+IvMu33+smh/+g1d2pj77sDwq0=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "3.2.1"
      "sha256-ejv/9CZNQYB0FUr0iE3BDzcwQO05nBOUriNPoQi6UgU=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "3.2.1"
      "sha256-bDBHtMBmS7CZlpZVcnQWwjZYkjtPYj6Me6epiMH/fj4=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "3.2.1"
      "sha256-V2UKyjSVZcJObD8MxSuKqpkRxDGNMjBL2ymXjq+FUNA=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "3.2.1"
      "sha256-SUJxzIOlWozII7wTtngKhKMlY2PZOdeGl7WulU9/KV4=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "3.2.1"
      "sha256-OUrNnK7dk12zQHk5rJGYkq2jAkmctoACJXHjBlFVgUw=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "3.2.1"
      "sha256-pnb1rQSx9saqywByRavCVUNrJYpmPs71N18SGY6yDPo=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "3.1.1"
      "sha256-g+XQEgqqZul8kOg0kstdYMvw2tu6zhC9GZGgs7WH3Mo=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "3.1.1"
      "sha256-91tfoDjQoRqrcEcvEhBpIoB01KCZGMptnhT1jPhwSLI=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "3.2.1"
      "sha256-2vLEv5tkSnOyP7xnXQM7foj9LtsKt0jr27RJrkn18jQ=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "3.2.1"
      "sha256-PauOGozty1cFz8MKB3gOrsHiJBIqou0FsJ4fxPmw0eY=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "3.2.1"
      "sha256-dA36hWseFbqVeqs/q9NHvXSsKb7w/vZbClecKdHQxmM=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "3.2.1"
      "sha256-omOj1TdjCnogJ3/7fXjRM6Z30jTJUGLVpXoK//hnUW4=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "3.2.1"
      "sha256-oJLjNjRp0kF4eklm8GeFnEJFTrkmJukS2ACwnE/KENU=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "3.2.1"
      "sha256-cri15TpHfYUOoXy1Mh0zVKOs2gPsI5UvjlJOU+Szkyk=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "3.2.1"
      "sha256-eLRV9FIkbdvurf+o4Dh03JwrSkBmC1gqoxWYTmmniTQ=";

  types-aiobotocore-freetier =
    buildTypesAiobotocorePackage "freetier" "3.2.1"
      "sha256-/rHJTvgFvbGzd9G3/nekHdEZ8LNQ9wYd4gTwW8q5Q+Q=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "3.2.1"
      "sha256-GC6Hy1aarU26qvE7/Ralyp3rDXfP5vK6S4t9mKgPOVQ=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "3.2.1"
      "sha256-zyWZdWdNI9WYFzH50G4ee+L6KAjRZO/8HlDcRCLIx6M=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "3.2.1"
      "sha256-RgsVt4yCAx/QWcjVePVGQE63JZhFRzmFVXCG9FYFF5Q=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "3.2.1"
      "sha256-+L+Tk0yKCHlKXE+Alz/Dy6WeJ7gzSwkKM+qnDnP6dro=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "3.2.1"
      "sha256-cdToQBx5PYym+pF51brZ5KHAyRrChcbveIxLg1cEF9o=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "3.2.1"
      "sha256-v5f/22MseAvs4mr8JzSGzZ+XupsU5K2apDDfBK8PvDo=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "3.2.1"
      "sha256-EpP4arTgD08qugQTi+hD7tTbxUqFuWf82TSlGwC6Pjo=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "3.2.1"
      "sha256-AiwG8aQ5sUCL0lvsE4paacWPDC/yrtt0tYlxfs7ZyZg=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "3.2.1"
      "sha256-kqLeDSUN88R45pALL6aOfMTQd68peEvNn8FjWLUMjrg=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "3.2.1"
      "sha256-ZFVv+n1TYdzaqgfc9ZaEh3TbpNTGYpw+v5njCBvN9oA=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "3.2.1"
      "sha256-psB0ByglXTySUoAumdX68/JVHn6sW4lp6QJSamlFo+0=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "3.2.1"
      "sha256-pmGlBAxZI/ijx7VTh9wiJcfTJWOdQYNZF6QcwiwHsJA=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "3.2.1"
      "sha256-QmSmLk8XJzgbO3tJkKZkHy4JdMve2nRn3bPq4+8GOJY=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "3.2.1"
      "sha256-YdRNHMjzBWAv7JqriytCh4ma/tbKaq6WdoYx9FWQ8ps=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "3.2.1"
      "sha256-VAtCPVpnl0mk23RQaCOuZr5oEaJNwm0rRnb8Y4iDWqw=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "3.2.1"
      "sha256-AmDRPzBGPEEemYv34mfc6ZEsarsEG4fRa1RKmUl8FcE=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "3.2.1"
      "sha256-QNpwlDgw/GNco1e1LyHS1lZr/9Q+han11yxzI/kN/xc=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "3.2.1"
      "sha256-1gfym8uWOin2y+JHR2+o/QR/4DL6gdQjTiY0wi/QNY0=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "3.2.1"
      "sha256-lIIw8MPEmC2dZdTJZXGBRXZeHXiW06f5JM8aI4/QIR0=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "3.2.1"
      "sha256-qyG1Hae2a/Z0RwZQ7Aukcu63KrONMQF2Ihpk7qor8RI=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "3.2.1"
      "sha256-BT09f9w9+nfRrFRDQWB29pZrmoCm9nA4skb8en8pWUo=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "3.2.1"
      "sha256-BZINFb3Xaxr7lULFTsKwnfQCUfGrcjHzpsXbj5gGqVY=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "3.1.1"
      "sha256-Yf1vvasgtUxFiEfSrlPq0Q2yhbAOGyRATzid+qYjlj8=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "3.2.1"
      "sha256-9HuIiXz9ob2KtL6fz20zzvngDmniOzTWZYvWzZP0snQ=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "3.2.1"
      "sha256-eR/F4PaHjGZSHtpbXoZi3COMntlZBZHyZyYEL+abQ3Q=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "3.2.1"
      "sha256-T44lWUJGxOWZU/L+knpQbYZE6AIrgmki3K1S+k0ZtRI=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "3.2.1"
      "sha256-vbWcFdU+RUonBLoaq+yMcMGeRTSruvFVUj2unpLPa4c=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "3.2.1"
      "sha256-FL4HjOI9HTL6XY3KSNX+Uj854ZTGOuOB9at1Aho3MRY=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "3.2.1"
      "sha256-DRvHhkR85Ahr4jai0jJ6TRHuBBtSFq6UkQnLjYChwuI=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "3.2.1"
      "sha256-YlMesaZPyavJbNOwYdX2L8lrA826x9IlDof+Z5so9Is=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "3.2.1"
      "sha256-EGhPHBtCNhrxqfhDLBSGTiz1m0PAOE/+VTp9pfyte1g=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "3.2.1"
      "sha256-MtprSOnvZNVmRck5WhASSAux+vsYp7mjVqw82DuWG6o=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "3.2.1"
      "sha256-9duaFRstc0CdyrtG+IkyKRQF+MsnRWC3TRZQ0pyfgbg=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "3.2.1"
      "sha256-f7eZZcQ3XpqPJRMyqTWpONtssbQxbkq7UjftLmbqttM=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "3.2.1"
      "sha256-ELVyUPZ5HG9tPLfeQPTCroAPCmnSdlPFIEaovXh5G04=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "3.2.1"
      "sha256-BV1jDRSBWhJA0PHpX69AsW/zNk8157lD5TEtd2XMrrU=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "3.2.1"
      "sha256-Vqoz8fZKE0VM75V3MX2rzTPJ2UMhauD7F/3/0fHneU0=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "3.2.1"
      "sha256-9F409tTUXcMrO5WW1W+icYPa50uNGoFRgaPVrii7XHo=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "3.2.1"
      "sha256-FTfgUGJ1Kuqij4N34WsKAb6XgilfJq1//wmEqtY9XP4=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "3.2.1"
      "sha256-9o1dX1IGic5HswhpU6+EanVQy46Lr8DvxnCekiGMBEk=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "3.2.1"
      "sha256-WczxTlmTLeUsxnVKDMcmbt63ybMScJRpc3sCXG4Kl/Y=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "3.2.1"
      "sha256-TwofOitJ1Ow7ekYtI8nsujFvaTBhPWqE/Vz6vntbYU4=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "3.2.1"
      "sha256-8sQnf4WriPXkRh3InfjuxFfSDhYf3kl3J47T1CJKwLU=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "3.2.1"
      "sha256-uioUpzxKT1Xj1iNcOkrlZaUgdYoagqKV21CEKD/HTIs=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "3.2.1"
      "sha256-S52o0JK/cbeC9YBspUiZDrnXlSPQ5eh/hrj3nP+Zby8=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "3.2.1"
      "sha256-3N2rxTc+iL4UeQN0wvrmiFWnh5gY3+JbunTP+bhhWjs=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "3.2.1"
      "sha256-XTtHrbXtXzfcU/Y9/BFOIrCd5H5824dmCRhBz/3JUnA=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "3.2.1"
      "sha256-d9r8IfRbaGErkPJmJXGvbCNxCUU6xkTykbyfUVtKx1w=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "3.2.1"
      "sha256-xG28gKqBmpQ59GqK7YaKpxezhwc+aVlTnAnl7U9LQTE=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "3.2.1"
      "sha256-E7XWRHvbwZW8hgpE/xqKJBsT/V67+bfWmhoBlVBKLLQ=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "3.2.1"
      "sha256-738hgZjnnZiEUOMPK49Om6+PcoZ6NqegS15nKMAeCO4=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "3.2.1"
      "sha256-lNJcZgjb1pJEiJdVX2eESt4ock7lPM8wfejuc8XBbio=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "3.2.1"
      "sha256-O4B4Aq7BfIgQnxSqd6O/xu1kIBJ/0QbG0hJSuWC2Hzs=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "3.2.1"
      "sha256-pEzFmkUdiICdK8E5rS6UckzKSAc5O4HnqvOFc7X8BjU=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "3.2.1"
      "sha256-I/JgmAOnCcM5D9leooAVDiTCbQmF5bYy7Sknqov6csQ=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "3.2.1"
      "sha256-boEkvX1S5ryyJvMgqc+wOUkLW4k4T2vEFUn3gT3cKgI=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "3.2.1"
      "sha256-6/h4W6J8qXRVFlHfr5FFrMxOKDPPvjdO8/Q5IZxFqcQ=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "3.2.1"
      "sha256-1ynYmau1NOiax29w9lgqDTx0DfE+kztcQsAQoG7AZVU=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "3.2.1"
      "sha256-PGiMTl2XheFBiIicH0efeLPduEjkh4MBXSD4Gk5X2Go=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "3.2.1"
      "sha256-hTX+mATs050pJN+L8ABOs7Uv1Za6jzAtZ3BDLg75+Hc=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "3.2.1"
      "sha256-Z8+SYDyxC4VHzjkeRFU5ZIzBWS27odZc9e+WVsPlrog=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "3.2.1"
      "sha256-SSICvtlyLtFavBp8D9vjHOl7GDHN+eSWLM4vfpw4dnQ=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "3.2.1"
      "sha256-BN6xRifz7jMUOBqXHZdJB77RuB/7ZRB/vxh0aOSB4F4=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "3.2.1"
      "sha256-nRlA+RelYP85DRJxccihMaKKnDXy0fzVXsGc+hvrYaU=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "3.2.1"
      "sha256-HMODETSrEtk1CaHsNeN9bHC44B37JCIhWk13epeCP/8=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "3.2.1"
      "sha256-Q7oNqI+TYRrscYEa7V1+Iqg7W2hQLzBGCGVCV83AfYk=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "3.2.1"
      "sha256-ZeeNrUp6PL5xKaqCXOFGxHN5Y+rUP4wMXFWBlSZY0Yc=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "3.2.1"
      "sha256-vWGYan8Z1T8TFQsCkZwNVVEcMkyUKz6w0iS/Kei4iNI=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "3.2.1"
      "sha256-+AJBzPJ9JuUdRjZllHl0OK8H53l+byDUkyKbCxDcfck=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "3.2.1"
      "sha256-QBYh0o2BQKbLCBr/+HmpEc6JIQa00ePywQpK1yYCitI=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "3.2.1"
      "sha256-g6OQ3H71h+N7qNqIoF6sOQMlXPlChIHUN1o29oVNFSs=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "3.2.1"
      "sha256-dX4W8faUuJUrwI1UUBD4+Mnj0PQgO8tyA+0kkse3qA0=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "3.2.1"
      "sha256-Y+WCrFmL0yuRHLJfMwRct3ReIUEtWPHOgz9nq/gE9e4=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "3.2.1"
      "sha256-rmODBsHNWvO/qTdSiBgyoGT3hur+8jLnnD3U7Vh3EbM=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "3.2.1"
      "sha256-vx/QkfQAz43XA9+cCLE5E9ktHUwjfn/DKgwPMsnl0Ko=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "3.2.1"
      "sha256-0tj2uhkWUT2XwQnTsrqDiL+D/UJmbGCLPxReacQFbT8=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "3.2.1"
      "sha256-bGHz8CN5FDJn4KA/v1tjBQc4sTkV0ERMdUEa4Gl8WMU=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "3.2.1"
      "sha256-3kDlrFVbtEtG11iCn9w28x5O+PXDAaGrNyjAxtXBdBU=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "3.2.1"
      "sha256-9v1DJKboH/0yPV4U1vN40QJyxW/ZdJxuSmIe0ypMgug=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "3.2.1"
      "sha256-0IWgZUW0y5M5cn1C6u4XbRmsLmxabxuYipcA3TnpPaM=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "3.2.1"
      "sha256-M6LN5N95I07Y29HUaoaXOmOf6oCj5+Ghcw2EhOC9uNo=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "3.2.1"
      "sha256-Fty1B+miLuYOeSkBvVxvC1VeVoDRvbUsnTEm3Yt1wIU=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "3.2.1"
      "sha256-sw/dRCudCHwXO6oOZi1bEa7i4hqyqyZsYJJ3ivHBAGU=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "3.2.1"
      "sha256-O061rdUehKtWhJH6ApMumc4t1oZhriKufC8iL7Fg1AY=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "3.2.1"
      "sha256-J4JOv8+lmgsDVhu9ywUV4/YwaM/uemmCNN/VIKAlcHE=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "3.2.1"
      "sha256-SrigwJu9Bpmx3Lm3CA+OLaV/ckj3x6BbO0aeZ4Ipay0=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "3.2.1"
      "sha256-4NiHFSsqo7RJTsWSJj8/tcrmXmSgsPsc7gn9j7ZNJcY=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "3.2.1"
      "sha256-+rvM2g2VfaDw4CRaqhdoKHvs22OEUFFeU7zYXD8iYDw=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "3.2.1"
      "sha256-27kI5jdOfoZYy571GDVhuk4htdTUOTPGI7Mt2CDYBa4=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "3.2.1"
      "sha256-v2hpNF8CBlIgIMOyDTQi4LCvwLw3+K/+KyLr1ERM/xE=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "3.2.1"
      "sha256-Y5/HElUo9gj6hNS+vwh4CbHBP62H37VvE9vu0YyD1jk=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "3.2.1"
      "sha256-0yj1fLd/dNlfM600TgfjFvG3gDtOXB8Tl8TVCqJmHoY=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "3.2.1"
      "sha256-rBozUWkGMBQxn7ip199Scu8Th02Ud/Uk8epPqeZSqwI=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "3.2.1"
      "sha256-4FkJtmFJnBGIywbHrbCGTd6UM7jBuM+cUNDoQQIqV5Y=";

  types-aiobotocore-networkmonitor =
    buildTypesAiobotocorePackage "networkmonitor" "3.2.1"
      "sha256-EZFVXmK0hm6ygIMC9Ls1BaaFDVSJGYQn6fN4kM9qAEk=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "3.2.1"
      "sha256-Cn70pwIz4hlYaYVXy23yA3Tg9ghIhxyOv0P/pKuCDqY=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "3.2.1"
      "sha256-OHIa8WWdH6EVJCz20Rb3rjWewnO3r+/QdjCtYOMWd3Y=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "3.2.1"
      "sha256-wg4NREM5zqVf6x9AJA3Vvx8Ed9WOgKWKkw3H1QEUYb8=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "3.2.1"
      "sha256-5iJtkLAiXwD6jFAxAsqKuqw3WxI5SGSVeMravUtLMaE=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "3.2.1"
      "sha256-pz1b38H9c4vmzVqOfeiilGHaEH5L2iD8EJapJ+Z3hNo=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "3.2.1"
      "sha256-chBT9NaQWRybWMEZyunahAwRmxvP8BzqqbkffVYGGdQ=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "3.2.1"
      "sha256-7O8UnA7rwJ+EFMQ1IxslIjk8TFYXuK0DK7yTn1MqrRI=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "3.2.1"
      "sha256-K2CahO6dAokejWGa1nhdWWhEUHitgAhHPiBB6W4c24E=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "3.2.1"
      "sha256-/9+APJV5lAK/6PnE3bBqSgxm55Uh26exWB+So/FAdCo=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "3.2.1"
      "sha256-yvSZc1F6knLu8Ci+s6SeddHN8b/Kd0qhzisaHXANLOI=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "3.2.1"
      "sha256-ZNgyr4S+Uo6fOrLtC2FTSkQ0Fsufw+coG+RtRDoN75o=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "3.2.1"
      "sha256-9OLQnip1AOZW4aGu9ax5ZVB4f+7MNp2oGmT8WQ2MIIk=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "3.2.1"
      "sha256-JpoMishy4riLZrfg7soCOOkzmtUHQzTa8AWLOoGWk+0=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "3.2.1"
      "sha256-FZY/lMCSe2ftEG4Mi7qiQIGbu6Itxvv3EFQ9Zx5Hcls=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "3.2.1"
      "sha256-7ZzbL/J9DDTdEHRPgJBnas0DgE6iC4POf2HZlVgyoMI=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "3.2.1"
      "sha256-xbx3Ln0t3rYWweEiVozRqtge8TRaCX4nr2nxppBws7w=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "3.2.1"
      "sha256-ZW8w0/w+fhnPpTnVxOSTdfWz4kgeP+okMcQCGNywVsY=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "3.2.1"
      "sha256-TWz9Zy5gVdAuEJs0Y0ckDzNjHUlwEsmzsIKmP0Z5laA=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "3.2.1"
      "sha256-Ryofyph+nzlpbyeykgkRsROhuZqAUuvBx52+B99Wkx8=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "3.2.1"
      "sha256-xDELssTDlpKivy3g8lUdZ+w9YCcmtVc/1AjZoS6+bdI=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "3.2.1"
      "sha256-IxlKFeqJF4KtV1bvHYbAfuIvawV43thyrlp5xqM0vPQ=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "3.2.1"
      "sha256-SbO4tpkbv/ujGQqTyWqbFwHoWjtaHPkdYYI3/C109D8=";

  types-aiobotocore-qapps =
    buildTypesAiobotocorePackage "qapps" "3.2.1"
      "sha256-drb4BNL78H7Rx7YiAHGzvMLqrmh18f2l9vHJqg3Mx/k=";

  types-aiobotocore-qbusiness =
    buildTypesAiobotocorePackage "qbusiness" "3.2.1"
      "sha256-CA+sCkhQYQAcLK5k1G8kqOb/n08uwuJiERDEhVoVgzg=";

  types-aiobotocore-qconnect =
    buildTypesAiobotocorePackage "qconnect" "3.2.1"
      "sha256-cb+pJvi7TYzJpEQUhyr7q8CVgvPi8fOKg4uc/7yvYJY=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "3.2.1"
      "sha256-yMfVNyz5Zs8FX8Vaqyqj/zaaukmee1m+fNoK3C+Q7YU=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "3.2.1"
      "sha256-N6Kta9ipM5p+vZiruDTssdX3cCzhEjOXMTtD6HtbEm0=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "3.2.1"
      "sha256-wleDOoYpUs5NC3DZ3wk0/juq5H3CeudDCEbMKUZhtfw=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "3.2.1"
      "sha256-x8J1Iq3XETbsUlmICjiSObe00aEms90CqLTFJl9dhqg=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "3.2.1"
      "sha256-7IR5EN+obGVa21tbypj7jupBvn4jPyO81NKXKshnd0I=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "3.2.1"
      "sha256-iHrorMUVXyjtP/83uDcutVjIwHdleuF+TeNg6tOjUg0=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "3.2.1"
      "sha256-GQv46nPIc+4Im4h/U/aD3dqyCaAOLIhSaeMDdlR48ak=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "3.2.1"
      "sha256-dQZSLQS1s07W6yyTW4hH8TfDSUA6G1zmNeoR2+yRGeU=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "3.2.1"
      "sha256-w3lYR88KvRNm6WVqgFaGmgI8qCbrIuoxc+b2nJjIGjk=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "3.2.1"
      "sha256-7iGc+VdUXgoOWHrR3dJAp+SKyk8bBLXBXxi+vT98ODM=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "3.2.1"
      "sha256-4l0siyoydPTAT6wkRemx9/NxU3+iYq03y1dXhiXabiM=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "3.2.1"
      "sha256-34CPWuTG6p4yTuRcGz8sGuEL51BkbdIkB0fFl0YmB6k=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "3.2.1"
      "sha256-0FGrUwtPWAqF3RAoShfjG66IeA6JyXoCY8fypeUeLxs=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "3.2.1"
      "sha256-RW0b3lAq4bKHx1M1f6P3Xi51SZkgIwM1eIbxOKrVu5U=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "3.2.1"
      "sha256-DD0UA4EPQGlJNsVhOtk4oM3KkYs+3J4KnTDNkIBxbrU=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "3.2.1"
      "sha256-qo4vEPHdsHGSyiRJRKTwHsJexL2xf33TzdCbGBgisIE=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "3.2.1"
      "sha256-Ocaem8tcDUUqoXH+6Milcr/RznX8RG/RhEVDcHKnEd8=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "3.2.1"
      "sha256-3dJwWSPU0rBJGB0XU8PS0pIW0FUmBJo5gCxKwUeADek=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "3.2.1"
      "sha256-imMNgW31tuywO1xwaevphvNunBxGiiE7md6acTDEw9w=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "3.2.1"
      "sha256-kdO+4O1DTOHb+3rQBOL4Xd6oMsxnZsMxz8554ml0fig=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "3.2.1"
      "sha256-ib+L50tNmn/vOPJq1DPgJvmwh/6JHt7X0Uq9A6htlbE=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "3.2.1"
      "sha256-dk8I01LyzE+LhId86aTRAUtFsjJccPEJPtCcDOQfGr0=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "3.2.1"
      "sha256-GlgdKwD/GoTO16Az97Uy1pbDXC8XKi8/jbF/GS1SXro=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "3.2.1"
      "sha256-1WQlJ1eb1QV0Vafep7fjQudbuE0J3slMKYldO+Mz1P0=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "3.2.1"
      "sha256-oHO31YDRcuqPHqRuF5UWEfMw/d8XXY45OcMBSf9fYd0=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "3.2.1"
      "sha256-l1+tAyECU5T/HFLql6X89p5TVSc13wYp6821a1LZVaY=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "3.2.1"
      "sha256-YGkb+KAXlyxrBR/RS3KaxeDC8VFfQ6Kg4DvE0rrC4lI=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "3.2.1"
      "sha256-WEgn+iHqGSZiR/unCdsNTvUPL+l9tYE2YI9ZGtmfHYM=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "3.2.1"
      "sha256-YM2VJqs/st283b0KUdpNkJbvm+G/c3+hSuZwrCTsBH4=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "3.2.1"
      "sha256-JZzjrZiEqpp5UCQZI7W9beL/Ro386SZ6eJeeRiCeLXw=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "3.2.1"
      "sha256-jIsggsRIxPLDfUZTy2za0h0wd2tgrQf2glEE6zMrj6E=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "3.2.1"
      "sha256-OckOGxR7NO+5cKLM5tXfxeiJYTgCTfIdncnFMnommbg=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "3.2.1"
      "sha256-l8FQkWlHdPVRYr7a0qqSF+n6eQEf8+nwjSsGpuyh7Ck=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "3.2.1"
      "sha256-WaT2EXW4ElPcD5ydCjef31Es4P2cVNcAsCU+hq5N5aE=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "3.2.1"
      "sha256-bQQgqCQUALs2o7KQfPYGiXu3NxvqxurT5KGcaj5QkR8=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "3.2.1"
      "sha256-SiuMRDx2n1gPA0o6XfPqrdEU3kVdj02WUHLiXhmp/I4=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "3.2.1"
      "sha256-OKyyhx2bMIsJ5HwIYAbl9oqYTmaWpGUAI7gGZA5r+S0=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "3.2.1"
      "sha256-r1G7Rfo5KsaTYOd/FYAWO0EUTPMBYZc1vrZiO8RJ8Mo=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "3.2.1"
      "sha256-kbmRI+sXnHjPM7eAg4/HbG7GPICugK4wVxYzTLbKyTE=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "3.2.1"
      "sha256-aEsDKuYbigDeLxdnZGIrjsl/63t6MGVJZWVsgyKhzk0=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "3.2.1"
      "sha256-WqzkfEHCJoNstqZVZuLCJEE8heyxxxwZw4imEEb9Rlg=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "3.2.1"
      "sha256-+m31s4V2p9oYLN6qKs5TpOWeHzdnJ0QXblq9R8TreWo=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "3.2.1"
      "sha256-4E5myqfcIPFFQ7otx48T9A/gCrUrpDjl+oWeA1wSgwc=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "3.2.1"
      "sha256-H3KFx2SyFeWfYB+xue/8FR8r+vLV1JWI+RUBTeY8OdM=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "3.2.1"
      "sha256-NmooLRnWSfNjjek/4S2/YfUrM8iGG8RPw9WvDuoKT5w=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "3.2.1"
      "sha256-a4Hze1HDvvE+wVE2POvy6MIUxmKFO6gP7n7OYdOsE6o=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "3.2.1"
      "sha256-QQw4ci3AfhhDBf1m3oK9L90jHDqBk+RMBnYd47d11ME=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "3.2.1"
      "sha256-5wLihc+ysV+/1E56VgVe3vWEOcmFPR+rQV4yGJdYZgU=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "3.2.1"
      "sha256-llCNV+0mjmSuCIgbCa8lyktXA3LGZItO9GWaidr9p7c=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "3.2.1"
      "sha256-3pSluisKy9jKhT0zBhAmSdvjwcbbwX+MyYIKlBtW4lY=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "3.2.1"
      "sha256-T5E08DIC0dQD6nL5jU4Gh5/2YEUaVzkWbQxqTAiihKo=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "3.2.1"
      "sha256-ezdoSf7BpRxiwekVMig3/eAEzRW4BzaMq7UmBeOSKR8=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "3.2.1"
      "sha256-izy2pJjeqtAag4BHBcqVg8P0cw3OcJaE46blyYzaxNo=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "3.2.1"
      "sha256-k2R0UoZQ9Pk3sPGdYkJo8zmKmFRTWMgnlDsWCPSuN4M=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "3.2.1"
      "sha256-20X6btjnJZqY+P29VevS7R7FPR5qgv6JrmLzIO2Vf2A=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "3.2.1"
      "sha256-nh5k/voQ9zAa0eWrIFul76RU0XC78CfjalNFrVyLA/g=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "3.2.1"
      "sha256-haNNqchIECaKk5V5sjrLdttsKUJchd+UMFAny7eqpDc=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "3.2.1"
      "sha256-2T9HQlVH12X9VW4DDojcd1rnY8c6svR1k4GJZu/7pI4=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "3.2.1"
      "sha256-RDKosaChT4na/BQEH4tR4TT6QfMH9sm6BkjdJRpWL9o=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "3.2.1"
      "sha256-SSFjXz/5vJQspODERcBks9lMmd7ySo90Q27NQdv/BNs=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "3.2.1"
      "sha256-SZDNsYibr/whd6BNY/CQna7Mq49nxyQQOaW6N16Wh0Y=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "3.2.1"
      "sha256-8BMOt+2iD1E43j07JxWdBTpDlwydb84G90VkzP5qa1Q=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "3.2.1"
      "sha256-5J9f6zjbECSwORGi5DC8g8iY2yftY2PrY6gwgqBKlvA=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "3.2.1"
      "sha256-f7qqMLbiSgK4epSdVwaftyjDOhIn8BCUuWMsjZViEgk=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "3.2.1"
      "sha256-rgxSWlC6HyKqK5AkqMGVDweqV4ib75QCVAzMT9j3FKg=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "3.2.1"
      "sha256-3hFYV+9gYF2ND/4AwI+vx1mGQz/VuAF7isYhG9oYkh0=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "3.2.1"
      "sha256-F1aPcwbjlo+o/GTxg4b1KEccXiXQdv9rnCNP1qrLoNI=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "3.2.1"
      "sha256-SyI9y9b8HHBIUn+u92LKPxUo09ZSojRF/kqY9d8VLF0=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "3.2.1"
      "sha256-gfk9EVwH2KXxRemlvCQ6cMXELi5JSXXepxZ4RAfSCy0=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "3.2.1"
      "sha256-XXf9V/e/mdFZkTV8R1Zq9rf8hmS7x6FIXovsftRr2/A=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "3.2.1"
      "sha256-eY0kT6Qt2qqG7InUfXuHyeDXc7W67LUwYe62bikbUGo=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "3.2.1"
      "sha256-Ne5UfyHaw8GWDpzdlexcfl6AkkCW9PnBoRN2auOFUjY=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "3.2.1"
      "sha256-iiwbQ/zHO8wDH+Y2NtmSrh2pt0MpqM/+VHaqKfbtlXE=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "3.2.1"
      "sha256-ELayfahnDEs5NgcFkCZQgueNDk4yUTmrC2yZDouApsk=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "3.2.1"
      "sha256-vzozTlsYUv3TdcPnjkRmbbIjIs2NURDsGNzz4WZxaPk=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "3.2.1"
      "sha256-2TVVu/UvAj29n7TvubHkBv16bWORP1EU9ghQatw+Emw=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "3.2.1"
      "sha256-cnQIAurLdsk1qCtbtKsvrf7pnMvtTHr/1gEZPi5T8vQ=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "3.2.1"
      "sha256-y8QDvmY9DEeV/WdDFjeQx6AY81BtT/DxEbZ8QKtW+ZY=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "3.2.1"
      "sha256-yeWtezgcK0bsY7GNHCy9UuHo+XlD37+Nclb6yefAD6Y=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "3.2.1"
      "sha256-5VDzJnSubrexGvmPLPq3SQAIIprIhxZWLE6HO5IIbGs=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "3.2.1"
      "sha256-8CaQ4FPVV8Vca3lq1045AubWXH4N3pSOjElSQwBwtOc=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "3.2.1"
      "sha256-xbbFP7d++UbGEbJpivQBOccaWRemzRu4L2Au0zcxCcE=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "3.2.1"
      "sha256-Gsi/k1j7I7s351pvvzXMQZdmO039cFjKrjNnuANXJuU=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "3.2.1"
      "sha256-2Y9pIBJYrtq3dX/gyqKV9ZpQfnfXZMgdEBmcm0Cyfr8=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "3.2.1"
      "sha256-E54aTArfzYJkHxAbBQs0MMJrYZY6s/CBhKO+KSz8w80=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "3.2.1"
      "sha256-TvTQN7opcfy7pWZYpC+GGh+d++312ZxteeZkcK98exQ=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "3.2.1"
      "sha256-GjjQBqxChznqb07JY2Fy1Dmmh8zAL2FDPB6mYTbj0Rc=";
}
