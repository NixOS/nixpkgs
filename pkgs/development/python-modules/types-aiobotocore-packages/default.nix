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
    buildTypesAiobotocorePackage "accessanalyzer" "3.9.1"
      "sha256-wrZNqkN3/CrzpIQvNoy7gQgagEXB0jW9362r58AMDrE=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "3.9.1"
      "sha256-QKmM9grETU7SpXxEYSaHI0PgUQfXeU+O8BE72oN9h0E=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "3.9.1"
      "sha256-ofnBwDl+MdMYE9dQts+Ru+onsuN/WlUbq+d1pQ09uRE=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "3.9.1"
      "sha256-tj+AF5F4A9u5OSnm88SgdgOU7Q24bCpXwW9xAfuw51Q=";

  types-aiobotocore-aiops =
    buildTypesAiobotocorePackage "aiops" "3.9.1"
      "sha256-zlNVZt/o2juLiVN0fgMKEMmb+EM/CgDHi9ixO9LRWfY=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "3.9.1"
      "sha256-zpizu4dY6uWh0/0Mr3ZCqa53sIh7nIsSOisjyspaZAw=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "3.9.1"
      "sha256-OKiM4M6POv3SUUQSHlz3Ftm/4hDk9j8OM6Vnv4Qc7zY=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "3.9.1"
      "sha256-7VMPCz60dBS/4Xlg3/Vjbtf+aVTGNEeKDn3QpNCXB64=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "3.9.1"
      "sha256-Pkd5U0YSuyrHz+o2vC+cQ+svY4pggCEB3OX62kroSwI=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "3.9.1"
      "sha256-b6FSbnOi3KZVg2POjj+ik6Sp7HMnv+ldhyRbGRsSqas=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "3.9.1"
      "sha256-4395hBYc40YTYpUlry7eKjdk3Yb3zzj5AfDMwIa9NdI=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "3.9.1"
      "sha256-O+5PPdLJd90Ei41CEAezftlB/TH7qSaedOTagxFunsc=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "3.9.1"
      "sha256-WKmxGG2TzTh0AIebMe/2wqMMPniR5T+U2rUbMLKYR+g=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "3.9.1"
      "sha256-JI3dkltw4Zz5gyqsFaOtqEMxbN+qboVJoARYHsiTmRE=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "3.9.1"
      "sha256-HxWwOHQdH07pl7tBCA3C325xJ0MMcD1FMsGpIaVAl5Q=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "3.9.1"
      "sha256-pjmM8PgqC/pMYb/3dOkqxd0cjK77RnthFafZsPUPcwI=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "3.9.1"
      "sha256-31SOahiqI/YXhpZCMLAbKsz1V0DiXRFOIAhcGZWJ5UU=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "3.9.1"
      "sha256-9oq/jsT+pAT8XE4ENJs9Fab0cucunK5myY9Ek0fKkNQ=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "3.9.1"
      "sha256-feqItTfNxryN8cCiDZhRwLpA8TClTbjHORTqWmTVCPU=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "3.9.1"
      "sha256-llX0ZrS8sy5Pz9GZgM90VvT9YKhA+kcxKC/766RgOSI=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "3.9.1"
      "sha256-dRD+E1s9ZWIfOBwLpJDMSvZV/WaEBDKPeVcm73hPay8=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "3.9.1"
      "sha256-EeG/KvC55ZgY7a9dh42DVX1bR3b4VfoS+PTpkg9nBjY=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "3.9.1"
      "sha256-KJ6g2VtYw9wdGRV+apXNVM43bCAmCc7kSz1k7KxGJhQ=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "3.9.1"
      "sha256-WD4QQgflDOm5sWCuI2JDSsnQ8Hx0+SE22ey7LH58tjI=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "3.9.1"
      "sha256-FgfEtDvHBgaT7sBTV820/QLhh1FApP/kCTQ1xHx0JbI=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "3.9.1"
      "sha256-fvPYOl4PwDzgvUjX6iDtDiQOQCbliNHhP4J+YKA9oI0=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "3.9.1"
      "sha256-S7iqU83aI4CP02Uyj0rK/iftJ5Kkc9z/ydqpDCZHdwE=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "3.9.1"
      "sha256-Z7+qY4Ez0ADaG0fXOXPyFyaxge7fPcl0vlJp2K2DEm0=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "3.9.1"
      "sha256-64XRwgC8FHWew/Y7/CXA83sH2qOcnx/NPltAjSb0zzI=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "3.9.1"
      "sha256-TXbKJTdF/cUxDrHiizsBAKoZtW0UycmKV0VJSw1BYWc=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "3.9.1"
      "sha256-0tMVW28L+FV8uWQdGaANwlyyHnEUPYqBVVJr0mKSHDY=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "3.9.1"
      "sha256-xB6Bn7Es1BUPw0FTbo6G9yYd6GyPKKSgBU6ADwmXgyo=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "3.9.1"
      "sha256-LnmE4b/0c91DK9NC6HI8g1WQGnxK2GOVxLoP85BYmyE=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "3.9.1"
      "sha256-HFasczwxANBYAN5VYguTfeE/E/mFv+rlKY+79irdnEo=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "3.9.1"
      "sha256-QxasKKNKzqYjIKloSLendHNvhObvbPhBfODlRUHm2w8=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "3.9.1"
      "sha256-JpYK+ovOEfD7a9K0YzCr7hCmKbM9mn+YmamabSqJ+68=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "3.9.1"
      "sha256-w5ueOEjXuVhxrPgH4wAh/kc4QKJFHEEpB7izpMCh1xQ=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "3.9.1"
      "sha256-Ku6t+ErXCvpJP6aMTmj0/1tboGjzIpRoXsBAvr74Dd8=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "3.9.1"
      "sha256-wuGO1kAsxhOSsBIU6WGqDuV+3SsyFn+n+qUMnwLl0aM=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "3.9.1"
      "sha256-WNrK+CKaQUyqQ+zBNRrM3pA5mAuyK5DaX1b3hTVa2wE=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "3.9.1"
      "sha256-nTJsNb7M3icOBZiIWPqIsbokCyMcWQICWSm1mLmTY5U=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "3.9.1"
      "sha256-vHv+Or0ADG5GWlq1ev72tovcMRkI7f8YRJa0yxeh1jE=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "3.9.1"
      "sha256-gLHozpGFWOCTY2Lrat939mbetMOptmEf1rKdvCxTcA4=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "3.9.1"
      "sha256-ZCqmLIuS4NOJw+GndTy5Tiz2DkS2S9tRW6WwgeFeAxs=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "3.9.1"
      "sha256-NSU2LVhTirOtcUUK3M6pPssThwGZVC0Qrcjjoxtt0ck=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "3.9.1"
      "sha256-TBtvIXlW4oBzPC0rvwZnxEkaSdkStH2SeCxZg1lRRyo=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "3.9.1"
      "sha256-qGSmzGa7LNdysbTJEQYhrZ94S9mfNTZ6mb/trYrLWkA=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "3.9.1"
      "sha256-IR2p9kftAY0Ns3YEKGZw0pKGYhV32F9xVsTtsfnecTM=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "3.9.1"
      "sha256-RpbElt8CTHqOxtpy7qu0JOnoYWReHhCq+G6qXPDKkUk=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "3.9.1"
      "sha256-yEGCeT4uWgTjw/Hmj3Ba2yMRLeivgAFpbweeFcuDwyQ=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "3.9.1"
      "sha256-X5G3UrOYVF4G33Z0V0BbGbeI/HDMB+YORc7Pd4Ss3A0=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "3.9.1"
      "sha256-yFUHelyOleV9uHyN80ignB2IwTHDbbXLEmoEyWhJV9E=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "3.9.1"
      "sha256-yCCzpUWxbeYhlvCZJoLknrGnLu4TSB8OUqCQ3T0N+ls=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "3.9.1"
      "sha256-9ZltDoal7NoqFHgtIdmgwOX2nD+UjjOytFjCKCsKtDc=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "3.9.1"
      "sha256-9YaZA3n7h5zz3Aj0CNFNkKmnvzz6Guh6j+7tbqs8K7M=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "3.9.1"
      "sha256-0BNPgBtqhwbxS4HByavm9oYhnmM+k0cRyiQ6Ts2hNEY=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "3.9.1"
      "sha256-DxKhmKwmgXm1TCx9YWlDBuSR1LG5//VQyv6BAVvySEM=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "3.9.1"
      "sha256-bubbQLWF8Xz4n/iwGmJcQLzskrhaw/NWKvR8y9M3kFc=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "3.9.1"
      "sha256-e+ftSMY7oUMpn88VtyInO/3Lps2rLULflTKnLklV5dM=";

  types-aiobotocore-codeconnections =
    buildTypesAiobotocorePackage "codeconnections" "3.9.1"
      "sha256-MWdAHa5j9RgsbUzUvR0ynvdegsMzP2fOEwWMJtQjgXM=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "3.9.1"
      "sha256-zqJL4/QHtFu5mWhvO+EQidfycjlr5bF/VmQvrEse2m0=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "3.9.1"
      "sha256-RNCkh/L4ka0NRXRh1Fa3LnVpdcPVH3u4KnjPcXaE+HU=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "3.9.1"
      "sha256-I13h5TsvwjLxlp1UQRE/1weaFxFY1wDovrgE2C5RXsA=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "3.9.1"
      "sha256-fUtkUYmqoQ3IhGXyeU6dtSqNyPAkj3kfxR5lr/8Il1I=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "3.9.1"
      "sha256-Bbc20kflGGQ8afUh9LXdEF1mydfvAfugY2IapqwHEfI=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "3.9.1"
      "sha256-ehHwnWWkSgwm6KQzW0Ro8LvUcggeuZ6GBunIOaTrawM=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "3.9.1"
      "sha256-aoNZCTZ+jmOQpYNMgzxx+LfnvbzlSA1sgSrAY9PW9K8=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "3.9.1"
      "sha256-WbrLE9KEMFRs2EttlmEQxjzEuVMd6l3cB/aSpt0p3FM=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "3.9.1"
      "sha256-63BowcFaugfqvJWWM7UUrK4UxJkqUJABBZV5v1K1Knw=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "3.9.1"
      "sha256-nvNe1y5LszX52xe4JTJnhK0CkermaNmnj8t48GbTCz4=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "3.9.1"
      "sha256-E9BuLCWkMdKmxNDqexiBD4PdbZ5JneVi+Wr56RxUpAg=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "3.9.1"
      "sha256-0FSiM16wlpOJZZrOLmFgfKCGhDkbKaIcjvgJezVS7FE=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "3.9.1"
      "sha256-ZbiATpV1M81cMpz5G0pU6/6MchrS+JpaK4LbErA+Q5Y=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "3.9.1"
      "sha256-vvmWLaFXhdGGw3NofSwHHgWm0xS/kuUkit47wF0Axig=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "3.9.1"
      "sha256-56TD9V7MANAgX6UwqljKfHKkaEATj6v5RQaBNsX1B+I=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "3.9.1"
      "sha256-ChyN6V3kC8G3nCf8BtYCGFAdGfWNr9boEq7sSemyRZo=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "3.9.1"
      "sha256-KMR+y9g6a9kTFuXurNkd49WfrwvQ52rnP8Fh8qWNh64=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "3.9.1"
      "sha256-uWM+izGZoesKNF9j9Dt/xaOt6E0bu0VVw6XF+87n7Eo=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "3.9.1"
      "sha256-FU8DFdO5ql9R2pCWXC1rS6j0JrVQDkSA9WiwyiWzpqI=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "3.9.1"
      "sha256-a+lricSxJWq/LtL3lx4yRPhbVhXDBzaUPa62Q4JZHkM=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "3.9.1"
      "sha256-KC2RXfn8dYm7tWrClW2bsq9S+OCqOXkSSgLuSi20V+s=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "3.9.1"
      "sha256-FXsYgPv6XeMW0VYRfC1H7DbnoigEY6M1PO0KdWyXPTc=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "3.9.1"
      "sha256-uekaeFR8Nva3rSWgOsL2SjiC8l2VWvbkQ/Mz09VW/LE=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "3.9.1"
      "sha256-477/4acR/y9lm504R8vZlyoiQY9glzEmq7vd4T05wbU=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "3.9.1"
      "sha256-7F+nalOBwsoNDe/8HaacoiyHE8RbOSq6rDmBBBBG3+U=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "3.9.1"
      "sha256-AxxmCYD9JuzJsSE1UMia28sJ3+KAyr+odGsDjT3wwAQ=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "3.9.1"
      "sha256-1L9R3ZO2GCys5mj8Ow6MctCZJbHDoALjy3B6/DVFd14=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "3.9.1"
      "sha256-ZH4QWTcz4tUuT3KCNNE+a4j34l18HGvWzI8KJVTBROo=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "3.9.1"
      "sha256-oGhau/FOdioIjEjutuWDGGj7HPwiWEqpQjR566XEW1I=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "3.9.1"
      "sha256-N/u/XD6Lu76NgtiXOYb/qb4/GjQRyinJ7JOkTEGzzZc=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "3.9.1"
      "sha256-friIR2VEP3n07qY9tp4pTtx3gnd9i25SMmWDGK5TWQQ=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "3.9.1"
      "sha256-1gJzlhCCrMLNtkkQ1S7+3jMGhYQimR0jiCq/8GHKx3g=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "3.9.1"
      "sha256-0Rr31n6nqTTcUcvXbhAyvn5aZZG6/wfMvp+1NhbtS6E=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "3.9.1"
      "sha256-ex+9e8KFPLftjgakIG+Nqi8QtVX25rvdf7VpHYNG4tU=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "3.9.1"
      "sha256-t1eGv3siUeDYtp3EGeGycr3VhuHHSVfK7Jj2DLAwCYY=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "3.9.1"
      "sha256-YQhnAHQxm+nEFuE5Ct54pcyucpFlZ3JXIYVnXvbmDSc=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "3.9.1"
      "sha256-HkGUuGGrJ+cWJSQq+7Sj8VsptlX3TemkRSQIYTF0nUk=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "3.9.1"
      "sha256-q10r0NLVHZXeK/hw5P8FZCgLxaXZzvuouZRHlfMf9PI=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "3.9.1"
      "sha256-OwFw+W01N/JodzUSpBYWe9kYm0G/feCKBJpMXEw8CWk=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "3.9.1"
      "sha256-0VU0GcIGhqhynD/0VzW/c9ZiwSCOYI7juCKYi+UL21M=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "3.9.1"
      "sha256-AkLQxtnrHuYesU1rzzUvFMOVACzMVnW46BPnULXRAAU=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "3.9.1"
      "sha256-6y0CBcktBQ1XQ7Zmts6ymkYiSMnwKZDACDfsy9NWMQg=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "3.9.1"
      "sha256-PAUFaNel0UiSIbyTZCjjhoCShHGe9lh9VSen96GwH4Y=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "3.9.1"
      "sha256-BmkCphQ+evsFF6x+U0+6FdCTaUjz7DlqARRDtqFXd7k=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "3.9.1"
      "sha256-l+03FWNnkbQt7Enp1PCxL+kOcZ6sY19FgcfP5LJ6HkQ=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "3.9.1"
      "sha256-13NcwO85pJzPzbfDIxsXI98h1a9bYgWD6OhJMjQT71A=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "3.9.1"
      "sha256-IDChG6gUOHoGJQt/qLea4LRkzzPj4L+mZtvE8GOqU94=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "3.9.1"
      "sha256-fVLrJaws/4GB6xQ8vqhuaqHXmEZyGDHe5pKI+DniQm4=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "3.9.1"
      "sha256-qv4iZS63j/H5GKi5kDYVv3vkMcRnG+zdb7veqMcSn40=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "3.9.1"
      "sha256-E7pi4Elo7a36JTiO4OZ8VDdWBhj5ax2EffzaJUbqwm8=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "3.9.1"
      "sha256-ACdgKpTlv0PcAqQ3Ro1Mb+PUYGvReKGa9JsYhsI/3Lk=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "3.9.1"
      "sha256-gf93eAc054WkFE9dlkQflbZGiGta43lKrxUCA9Xz9tA=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "3.9.1"
      "sha256-1hN5EdGb+HNhCnI1vcAXKcIV9L/4w0WlVkTVdF+7UfI=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "3.9.1"
      "sha256-J/S5bTgz1XjZG5YbfabBhlwszcErZndu1pq14kJRCxI=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "3.9.1"
      "sha256-7dDZXPnAqxsNkrso9QseGOQgiFUPkPJY5IoWxm7Xf0U=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "3.9.1"
      "sha256-1F6xN2K3KWHrIRtT/lviuhbpJISXH05VuDeIR+J3uNg=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "3.9.1"
      "sha256-wclKk+U6RXLqvlkG/U6L3NjhQqpZ8Bp9FnMoLemAzBE=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "3.9.1"
      "sha256-lgv6T8/lK6/up0mZwGjtP4xYM0SnjSW643Q1qUFGL3w=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "3.1.1"
      "sha256-g+XQEgqqZul8kOg0kstdYMvw2tu6zhC9GZGgs7WH3Mo=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "3.9.1"
      "sha256-N9JwyG5SJ8Zd/Q1jnm/ttDaP4jqkqpn2CUpr0zh5pGg=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "3.9.1"
      "sha256-LsZtG75bn8YYDrX1FE+W3Df/YZGggyjtkvX48xXYcSc=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "3.9.1"
      "sha256-/7pMon0W4dkODyh3IK8UBNqd7dBiUvbmcsa+7fe4A+w=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "3.9.1"
      "sha256-f5Mv0hVv8oYdt+ppetlvQ/51pmuRY2ZyDtP4mudOk6U=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "3.9.1"
      "sha256-T6a/hHPnMHucv1biT83qoejS4/mZMFHnyfwHIChShDM=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "3.9.1"
      "sha256-WCZHNWHksRGHjB3e9GGCR7rQlE/UTEkLlTK25d8xrws=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "3.9.1"
      "sha256-ip+citG6W41ALV8WSJf84f+SfOMAIR7XePrDULIhiaM=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "3.9.1"
      "sha256-LI7UytRCihgfFGqviZ6ks2BW4Fkq/uWDULsJuyfG6Zw=";

  types-aiobotocore-freetier =
    buildTypesAiobotocorePackage "freetier" "3.9.1"
      "sha256-RE2H78+wwucRQXMrrXDMDZXEEyhHRXG4LqLTjlGR9p0=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "3.9.1"
      "sha256-oAeIEOZXbUtW7IS462EYE1IZ0i0ZI1COzljfJwMgOvM=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "3.9.1"
      "sha256-wIFqRgweSSIgeky2Jkb5PPSx/nOqX/ZoHGbURC73VTg=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "3.9.1"
      "sha256-NKaTBPIWDF0EkfxTWan1kHZbR399QsgNjFIGglY19sk=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "3.9.1"
      "sha256-GrGhx+NEI3yUgpQ4oet+BJk6bwUUngfM1S8ge67zwyY=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "3.9.1"
      "sha256-Sxy0UCPSdsTgtmrPxCUMJ/xxXgz6WzTVdFg4UVC7dN0=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "3.9.1"
      "sha256-RrTD5zMsuGoiJkqIMEpqymFAj6Sxa8LgpilIfpx254w=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "3.9.1"
      "sha256-PfU9ZwRB4rwIYwD/HLJ2BYpvPRgtBu9/GzKCxByly/w=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "3.9.1"
      "sha256-sy5urmt3gLoflbc7H1mD/KFoFDEPUYC+qgi9N6qk39Q=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "3.9.1"
      "sha256-uNAmfjklgAN/x25FVgAq3B8yol7XoobmmcLuA48p8I4=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "3.9.1"
      "sha256-TyN6IdCl4T5hcKY8Vv06lwyauRLHCUirUvWz7vP51SI=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "3.9.1"
      "sha256-2f9+C2aK+qN6nR+p3x437RsIJ8o9SolVi/txVtQRFuw=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "3.9.1"
      "sha256-UX/Eat1Eruv4sEGCYWPD+hgNRj2K71uwSpVEXKcEZMw=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "3.9.1"
      "sha256-R6X8E3W4yt6C4Zn6HcJ1dBJQTDP0M0JE0o6TaVZXS5Y=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "3.9.1"
      "sha256-VLHp/YAdSkYr7PljPj5rLsDTxhE4dHAwsme/jFLokPY=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "3.9.1"
      "sha256-O6q1B4BN82lpB93kjP2X0HCuhHQsBEP9wGaXcjA945g=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "3.9.1"
      "sha256-UwvNY94YIf0ET5DPjrboWwPmZJ03X4+CIh9vmrYbQaA=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "3.9.1"
      "sha256-P0TUIsWZx7U7PNsB67yBxX7I4JOZERypmfci2qX6rY8=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "3.9.1"
      "sha256-2dduKVzqJ6o9qPoavey58sjkRKpmoh+NhROIJn9WIfU=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "3.9.1"
      "sha256-QGhZ6pIbAblXlkZLBKY1s50FCvxriebfrcbCUDmFFt0=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "3.9.1"
      "sha256-SLxqC1c/YiNwr9wThGwrIig4gQiVfd6zcbufHsruXVI=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "3.9.1"
      "sha256-+yIrK+oBwI/S/5seNKdC2gbufiO6f1vcVo0mYS9m/Xo=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "3.9.1"
      "sha256-qZcf43o+NMDSZYVvUzLbp1PEkZOtFbTCXoH2e5ZcT18=";

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
    buildTypesAiobotocorePackage "iotdeviceadvisor" "3.9.1"
      "sha256-pJ7rsgf4aNUHTQaC3iSGhSk03P1dVXLrXgIDuecQ/6g=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "3.7.0"
      "sha256-isYjEnViFGsgtRDb3Y2i9vTCjqDcB88rM8JmxhpxIII=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "3.7.0"
      "sha256-FZZowHBNWFF3pWDNZIG12vR9NbWfWNWxt+IJvZYlp3Y=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "3.9.1"
      "sha256-oZPnBJEYxNhXmMsvHDCEiQj2yMLb441GnourYUGLMws=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "3.9.1"
      "sha256-cfpdtSnEnXRx8y13KFsuZhF3pgbHSim8gGb8eomupO0=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "3.9.1"
      "sha256-9C+eLkk8E+3mXKHoS1S6+uUYV0J9yzUlZvkX9lgOL/U=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "3.9.1"
      "sha256-Y2htwWOtPttzqV7HQY9hC+4JtRQ57yvMjvA4HbRryOY=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "3.9.1"
      "sha256-+viJyzf9vILimr8PM6uzsH5cySf5Bix8dP+cRQEfF3o=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "3.9.1"
      "sha256-Xk1CmCkxTGZDvAxoUm5LNL0/dSqjRuXFUH9dvnJW8KE=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "3.9.1"
      "sha256-PoHu48NKOxX1JuUY5WhfE80DjwHQY74O4cetnQ5aUH4=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "3.9.1"
      "sha256-ySt2IFsUCQbym3PVAC+vjiHyGvUJVTJCks4u8Oyg4Ls=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "3.9.1"
      "sha256-xHv22a+xgkz1+wFui5Mp/2MoMJYXqX3WxFH0CVQ3QJU=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "3.9.1"
      "sha256-S34t+p0ZY1i/6xBe3MBUTCTWKCW2cwqQomaqqjM+dHE=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "3.9.1"
      "sha256-kUcGw4y9znbT69w5zIO/Dq7vvgQep1VAZ2W9hckjIU4=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "3.9.1"
      "sha256-oVMbceLyPgnTlgPn8B1JZcBE4FYvfIez7LFFVUfIi/8=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "3.9.1"
      "sha256-SoesVnpoHpfqmA67ALQ5x4EiKWt3HNWWNuHIoKg98vI=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "3.9.1"
      "sha256-VdDgVQSLPcJAZAChvqmMuKxWbbaJKpsdRHX70vQ+myQ=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "3.9.1"
      "sha256-bGlN8ha2qV2leVe9PxUEPU5sx1kn65i8GPVaG7sl1Co=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "3.9.1"
      "sha256-oJA3KZXd9LPTVG5lLOD6wN8Ux0MGNrq6LsdC/xc+lyM=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "3.9.1"
      "sha256-QmRztBopTuz/S/8q9q/hw/6cKuzCCzwGowrdwJQPWwY=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "3.9.1"
      "sha256-GFleGiOD7245kSvnYc2MDLSX0iSuVNu+5hG1p5yY9vM=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "3.9.1"
      "sha256-05nNy4RWkOGpMXkYs1XRMaReCtbwrSMCUG8nBUQ684U=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "3.9.1"
      "sha256-vFFHk0sdtKB85n3VdLPvoZYLuwK9GxPIFg4Nmdj7YJk=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "3.9.1"
      "sha256-M5x5o3cAOQ8dmm2zXziLZnsyOnSYZj7Muf0lEjEB2nA=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "3.9.1"
      "sha256-C9voZ4L19/PZmg/V2cS84pMYzTVkYe7Oy+lHiIM/3KE=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "3.9.1"
      "sha256-x9tc+IZcvk6bVBae6jF2YKuCm+ybKtZXyPJu7vhU10g=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "3.9.1"
      "sha256-fpQIg43RchtXl7I7uKB8uJkyBkOZzkfhfx4VsWUDwx8=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "3.9.1"
      "sha256-zPGZGLhDfKg/5VQq/twID0DkQH2jwCTwrygejV39CG8=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "3.9.1"
      "sha256-tiard2SVzF3Va9LDo1TmNa71+0+wT8DGiG03CtEOyYA=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "3.9.1"
      "sha256-5jC08VYyCn+SMPK2VdsHgp1xkzObXAD1bk2k41KP5EA=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "3.9.1"
      "sha256-2ipAefj4FPTDN/T2DKBeYx4vxrvnXX6aL0FwDHzZUjc=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "3.9.1"
      "sha256-vjWGQZnwNNMs5QYD4DjO5iFfvZIVupOCv2ZRwh2P5uA=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "3.9.1"
      "sha256-XM/XyM8MnTBZmKanH3AOhuGE9ffBznSUPYjI5OJdDeg=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "3.9.1"
      "sha256-VaFVpw2n8WEzPAGm0XMUlwqPJMS2OXAnaH3E50vGBCE=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "3.9.1"
      "sha256-h2ZFez3xnCpCn9jqyIZl+yldabmgIqff0T0gdg0pBeY=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "3.9.1"
      "sha256-g3hEmqJC3Yny3NI6RO7S+KKdvmts79Gicq84xUPVWHI=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "3.9.1"
      "sha256-pSYhZeSEOA0/Qog16PCxS1xc9VCZje/qQYLRooj3Kvw=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "3.9.1"
      "sha256-Y+LivTcrmZ0am3IokOP+B9hlWNp+L3VY4gygz+e3yrs=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "3.9.1"
      "sha256-9CaYx3mRzuEw4XlC4EZXjn3Mq4QJRJeDi7dXLRj/l9o=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "3.9.1"
      "sha256-r90LI4LcpStFHQUVA4jGSxDzUlN+lLQaQqUt4v/Lqjo=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "3.9.1"
      "sha256-WG8n9JjCP/Xacb0u2rtEi4u0253s0ZPEFUudBu6tAx4=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "3.9.1"
      "sha256-iNiK1T88ly29jrHT0ws7jPsaIwBufjjXCNM7wCX5h9A=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "3.9.1"
      "sha256-y4CZpl1hXwU6E9A7FvHIPZgexjL51mgqUTRDvsqAzBY=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "3.9.1"
      "sha256-ayQ3orEJgDua9CXS5fZ1ENYf5N98OKXxJTETp/+Mlzs=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "3.9.1"
      "sha256-qtIqWvmG2FA//Vr+O0yN+5F5TvmcwrF9l0KhsOAdT/8=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "3.9.1"
      "sha256-WLmSiEXsTSvqoGqKXdtU6UsyeBo1GKcD+PNrTo/PwiM=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "3.9.1"
      "sha256-jPdjcA9ERx6KZ01QewaIhpaU0EVijVJK9tEWMePZwws=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "3.9.1"
      "sha256-M78PKJQm4mk1eKIejhZ947Dv8Wgm+HuUL/B7obCY7as=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "3.9.1"
      "sha256-/9nB+w/HY8mpsTxuhw+/Fumr0GWhNpcAzDVyZOfr24Y=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "3.9.1"
      "sha256-+3tV+eoRhyKZ28nnrLNFtY+TVASntvwarPJ7NmZKHy8=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "3.9.1"
      "sha256-xm5gZHiWx63kehkrrl0hJ3Nc8wk5hIruwhTHUAf1Ah8=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "3.9.1"
      "sha256-ve4XyMrEJaZ/KYEKpZkkktJnHaIgaqwBLIW5omWULKw=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "3.9.1"
      "sha256-hA8Lm+BYWmL8IJgPWhdGIUaLkU8LDOMS8d3Br5HcHlU=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "3.9.1"
      "sha256-fcjoxn/THe5m6aMghrlqygRUk0SUdDJIfXJOk9YHW4k=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "3.9.1"
      "sha256-FtVN0TwFvKuhyakWoASusMnhoSD4yzoonT9+NZc7sdI=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "3.9.1"
      "sha256-jhtQdN+LdWV00WlUcmrZn1sjXLkLSjO5DY2/Z5SzxXQ=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "3.9.1"
      "sha256-p9C8Uh6TkkU7iOHJVbr+facMG17MTq4KTR+f+CdrrvE=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "3.9.1"
      "sha256-sr5oTXeB0hAUuL30g/hhE0MROHv2qhoMS7qVeC/UNHQ=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "3.9.1"
      "sha256-SCrnNmc7KGRrSWJensOlvIEGh/Yr9uI0f2mM3PnDkzg=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "3.9.1"
      "sha256-8AtxfAnF81G25K+kThI4j8QdWCxYA0f3bh5+3hAIcu8=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "3.9.1"
      "sha256-sIWW7wAg6+CLklDspdqJXVxCdCheiSTHxk9EbCfHrQM=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "3.9.1"
      "sha256-tgsSc2R0cIuPfez3ensiA/JspObx+YkuOiHLCZXt5Zw=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "3.9.1"
      "sha256-5l7Au55kYSiuuZM17dIX7cHThHppy1+XjYVz8tSwPnM=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "3.9.1"
      "sha256-usTeb/BKM1NQGepQW+AHKAsi+pN/VKk43VIbVMHbqJY=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "3.9.1"
      "sha256-8Kp/e4iZANVZxyJm/NUzcVarwbHSxHrElX+HKqslHGw=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "3.9.1"
      "sha256-c9qZVxdbbvXWZLD26H2bNWPXROqf6QSwJ9WXTTYUwYs=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "3.9.1"
      "sha256-RawEdhzhF7rQFgfNloDeA7J/5OoOQ14M0Fn5APMNzdM=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "3.9.1"
      "sha256-0wvXQtPxpxRgOHzTyky6UP/+c92qAPsFbDhMVruWyB4=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "3.9.1"
      "sha256-Chr3T5buGHFM90RB0O+8VZ9oNsO7D78ty+X/kInAuC0=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "3.9.1"
      "sha256-QgdkJX3LNP4vWXGxAXDM5fWw2rq7ygfmBy1ympEUmpw=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "3.9.1"
      "sha256-3Fxm9SQUBCTVRZ1Fh1PVKJf0hxbGQ4+LNX/Bp79L7fE=";

  types-aiobotocore-networkmonitor =
    buildTypesAiobotocorePackage "networkmonitor" "3.9.1"
      "sha256-4ubTKwZMHQ4TkAOhT6ZyODJRhIOfZqda8iP4/neQ6h8=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "3.9.1"
      "sha256-avV97Xk8HJwZ2NidRkv9rq5qVzgx5sdHpWpN4okajfI=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "3.9.1"
      "sha256-7LyTbhdPOWBZAQUs2SYdq6dcT03JuQ43GR8MELQFOeM=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "3.9.1"
      "sha256-DygCKB7iDl/f0BOV5W84dvD204qQS8OKetzjyP7NKBg=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "3.9.1"
      "sha256-oePQNt9RvKxHzEbR5Qd4MeQWU1gDY6EIITUwiDkuJVY=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "3.9.1"
      "sha256-w3kMZUBKu45cr20L3u1/akE8NNDLz/ySTMl6SgGKd6M=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "3.9.1"
      "sha256-dfFvlgFpJwOERQ54jNqlPY3I45N/5xdUpqnd+UyoUeI=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "3.9.1"
      "sha256-vi4nihnWdJmpc1cXR1a/iobcfqZKmdtfWfM6D3xH43Q=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "3.7.0"
      "sha256-yn1EAIvzNfFR1a3r8y9Ri5nOdprgEAYBuXw2Wt1hYIs=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "3.9.1"
      "sha256-EKWnLGxoMNzglDM/o6x/JNJJQqNcRd2PUDwKwwYcIOA=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "3.9.1"
      "sha256-Oms38rMz9Tc452zI6eQ7GwvTlml8LU57L6Tw13Zx2r8=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "3.9.1"
      "sha256-i360Qx6becpyiylp5HP3v3qIq+Lwq3RReOSJ+5jE+pw=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "3.9.1"
      "sha256-qcNUd6nLWS5Ny/5vJfcU8TWaYsNRh0xGzHMetSuohjo=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "3.9.1"
      "sha256-gvy2jQcg1RLFke2ilmcp0d0xiYegerkTWDG6FI4r/EI=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "3.9.1"
      "sha256-+SIbF65voms+dzbntz6ql996R+lICev2B4k6FR6wrJQ=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "3.9.1"
      "sha256-/xbPEWhHge6vs9ONpUbGJ8Kv/mF2se/DDt6M803O9/M=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "3.9.1"
      "sha256-7kTxAqpB+ozVEmvOfiia6EujIDzFvSzCxBG9siLRW1Q=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "3.9.1"
      "sha256-G1bdQ5ExHCavjo/AYXg3/XjY2AHVLyYi2H/LKVPUpDk=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "3.9.1"
      "sha256-kvbMa7RIun7OdUVUY1jpgY60+pWDQq32pamMd7n3BGs=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "3.9.1"
      "sha256-gMxos7fxsb2eGpcZcErmxvM02iu03v4B7LxFvMIGaYc=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "3.9.1"
      "sha256-rEJ0aGtx7UdrttHCnX0rjVwdLSS3+0G4RNuA2H2otRw=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "3.9.1"
      "sha256-O6VhqlnOwoNtq3kK2ctpCYNFB2zSNMeCIbfj3r8nFWI=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "3.9.1"
      "sha256-o0hp4dqLNLA1yBEPRGaR5iOqaDC8SDE1WLIquei9ZCg=";

  types-aiobotocore-qapps =
    buildTypesAiobotocorePackage "qapps" "3.9.1"
      "sha256-e2q6m/yqZ7l9p5HUwG76PDpSh7w5dL/yh844Xt7YXUY=";

  types-aiobotocore-qbusiness =
    buildTypesAiobotocorePackage "qbusiness" "3.9.1"
      "sha256-Q3oBOPFyeEnwEW2Yk+g8XkoPXydRIBVjtSb4r7Wbz4A=";

  types-aiobotocore-qconnect =
    buildTypesAiobotocorePackage "qconnect" "3.9.1"
      "sha256-Di34iGtTG+JFvMQt/CXpSqP18C5ywBPZ3DKOi6KJLds=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "3.9.1"
      "sha256-RqiM77ahHcRlk3MmKe1Wi/JVn/cadtpCxVHlt/a5eJI=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "3.9.1"
      "sha256-JAUNSTkxGbNFypQEJjrUh4oZE56kmvPwkv+bAXrJLvc=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "3.9.1"
      "sha256-Re8zm9sFeV1QzGRg3+SsR8vm8nrNZ+yDIC35NlWnQ48=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "3.9.1"
      "sha256-whDi4K3WQ652SolU/WBWfdN2BxF26KQg5UTy14VWuZk=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "3.9.1"
      "sha256-J7Zhvd0N4+ogsXMiNJIvSKhal3ogV8Iuz6+cj3jJab8=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "3.9.1"
      "sha256-pvc+LzbvhxCUNz0h1R/WJDflG5+oQRd52qMej9M4A40=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "3.9.1"
      "sha256-wZjgSaZ4cJNrmW3SB/M66qf9YcTXeiHcGWWqQs/7yFg=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "3.9.1"
      "sha256-us9LQiLuH/0q7zt5mDtRvrY9h5VWJ7wZpOCN7ln/a0A=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "3.9.1"
      "sha256-VXb3U37cYRoRGSNZyv3B5E5KqTDhU6d32jEQgwH3O5Y=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "3.9.1"
      "sha256-ekxnBsBWCADr2OfIN+AKx21DXw73dQydmFbwUkjmuRY=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "3.9.1"
      "sha256-C6UrXs3l4sc8EgznzoDOmm+eXgi2aqCuZ+yh+k0YwQo=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "3.9.1"
      "sha256-iOiP+75nAa4m9y71YgPHaLFajv9KFDL0SaT7tUGHYTQ=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "3.9.1"
      "sha256-bWElP+zbF2M7hNL64dAFf+NFD27PFLMKOXcZxCrAXiM=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "3.9.1"
      "sha256-xiboiy0FjoaOjO/1K/M/yPZgz7HPdBXocbbVHIw2jYE=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "3.9.1"
      "sha256-KP987FmYH+49Mmmul6W3r561JrmMY10a+Rx4d0jFUVg=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "3.9.1"
      "sha256-JW9XGu2u2qm5XCR+/CCIsux8EFO32Lj77wXYyTwwLw0=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "3.9.1"
      "sha256-3Rj6POzv3bPnvmvffdhQUn12t0btgOs9LBpFp7Lfnb4=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "3.9.1"
      "sha256-SGh+jTZRUUM4hgx4NBwo7e/7F0m+TK4P3/CBhIHjVZg=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "3.9.1"
      "sha256-3GCYRTPgA3biXFRuxIa6JWpMjBq8TmhAeykCV6Fl91k=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "3.9.1"
      "sha256-GTO2WY4cCSv9vPzEOIghPGzVEgPk5fUhm6cw8yIFBdM=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "3.9.1"
      "sha256-58oJxT1rmpzpaHWFrqMrxDF0ZxaM+8R+DEPYbbDT1uc=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "3.9.1"
      "sha256-7H43WVPAX8ovJWC3uLvOoM8TbkIm+e33Lw8jbsC18gs=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "3.9.1"
      "sha256-uFQbor7ZmjSxaOLtuxGufI2kEQwQLresn1L0i5r+3WA=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "3.9.1"
      "sha256-wwMc8A3TSb9BFxLikQ+g4bYMZpIW8HFuCjMpdUbDFyM=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "3.9.1"
      "sha256-a93S5K2W5eW0nO/J1GYZIOXKPfbprCe+dBD4+MRycl8=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "3.9.1"
      "sha256-C06ynUhVUvRJhGsnUt5QF5Gxdo6QtBBlPaLWkIgP+e4=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "3.9.1"
      "sha256-AHEfBq5B/KYUDTvO2GXLJ8vm7MIWKsZRO4t/XZI/WV0=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "3.9.1"
      "sha256-irEQhLn1nCS1K1sNuFHNoxn2itI0JdPZDN0DGtD9/ys=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "3.9.1"
      "sha256-qlDJJIGFYLULkEfQa1gFoAK7hQ+CwtEaSjYPFwuEjWo=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "3.9.1"
      "sha256-sIQWOsULCqA6KxtYuxVcMQgH2QPxJieB+rcVB28juOs=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "3.9.1"
      "sha256-jKbiB+dfaRsxraar015WVXHx1N69e8x9v7MPwTTvCXg=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "3.9.1"
      "sha256-2aT7eMbC3KUew+UxS8LrZlrXaDb8XsHth+dCUx9CPHg=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "3.9.1"
      "sha256-K8Fy1Gg7UKb6JpLh6363vRAoFwhcZgjz5rx6Nbg8Sug=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "3.9.1"
      "sha256-keb7HXY5aI94cKeAPFwc4zXFtflCY1UlfCZA3tbsEgI=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "3.9.1"
      "sha256-puMlwxqhMvdQ5X1j051ozL51Ih5QsDTGqro5dibbZHY=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "3.9.1"
      "sha256-zdTN7446hYwVS1Ro251ES+0ionyv6aHeZ65DkhFbV+M=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "3.9.1"
      "sha256-/r95Fmg/4+11Tg1sCMfNaiHduhjofJDhqiRpB9Aukhg=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "3.9.1"
      "sha256-/ws2XOH7ky9Wz+j3+iVgdkZaMw/CuGDY4HUfrVA7XeU=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "3.9.1"
      "sha256-1/sUgJmSfkqxKHw7rRTO0Y3Qx9W3EzUW1KG6dPlpSh4=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "3.9.1"
      "sha256-0fV1GhyG2Q623XgP7gpnobC2XwPxXmwsHdhGn6R8mzI=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "3.9.1"
      "sha256-MQTI/CYcVgZEfdaTKcIYblMsrkFeLCrlUx4HHAlWIYg=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "3.9.1"
      "sha256-vPaYSQnA6t0J2Ss7fu7YGGDXkLxwWUCYh7uVuR8IrD8=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "3.9.1"
      "sha256-JAQLlZn5McifpGTcEPnqIlyoXyI2UHjPM+FGk0FctFc=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "3.9.1"
      "sha256-2HbJg7yBaf5WWQyZdH+CpSwf+Yr+Gcsc0W5rrzCzooU=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "3.9.1"
      "sha256-rITp+gUG0mLqcErrbj62MhLKo41x1kr4RFflieALkHY=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "3.9.1"
      "sha256-p79UlucBproYY/1rFv+Ewovi6sMy6OtNc6GXToVO5LQ=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "3.9.1"
      "sha256-F4gkwwSLiSOuZ+x7pDzIiHmf7WQqku6Rj+YrvzWomfk=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "3.7.0"
      "sha256-tZQL781zQI+vVvO0S3cHzw5RGAHKXeNeJW7E8tzCHA4=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "3.9.1"
      "sha256-1DWYgYIwviFHmbPmrJ7Imdpekwx9IZxT6NyUq+ZCt5k=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "3.9.1"
      "sha256-cZcSNI96Wcl5KL9BTOPlZdPYfX6z3LWdvWjfPqNAaJg=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "3.9.1"
      "sha256-oa5hgyCAPsc+O8j9Dhp8pub1ne2VNq3IY2yc3s6a5mg=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "3.9.1"
      "sha256-VWfRYKpfE/zNVr2NJ1yC1kcI5mVR3kH2sVClei1JO2M=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "3.9.1"
      "sha256-tONd238llpULGIOENflvjiWkg+mZVmiaNcqIkdqe+Us=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "3.9.1"
      "sha256-3XyWjAnobsuxWH4gtr0MZKue7zZbSNFziquPvogVMaY=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "3.9.1"
      "sha256-+jzhE1/X2n812AmGWJe7uuoEIdwoXNt/HuEPdrxnYW0=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "3.9.1"
      "sha256-F3U0ihcybcQpL6Fj1Ot7Zpe8vB6OlI0diiQ05SXJgG8=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "3.9.1"
      "sha256-RHBKfOEfqhtyWC8MnMeZWLqayaRw7cJbug40uC7MvcM=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "3.9.1"
      "sha256-Xw1v9T0siw53ZiB2stLDzfo/ON/oOwU5dp3tc/wx3U0=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "3.9.1"
      "sha256-46SMcNT9Mq7FeU+GIyoFJbrTYGAXwvAQxLfprQBgA48=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "3.9.1"
      "sha256-QycPZn9ge2tKasIhH4L45VXF4rpiPzZz3Faja4PN5zw=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "3.9.1"
      "sha256-DKSv439EvNINsv6aTiC1m4bwPbSDUTqlWdVDNgdKPAA=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "3.9.1"
      "sha256-EQq89EqI+hDH5HlLloVTGEyiZcXskAqYA/xRtRdb7Q8=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "3.9.1"
      "sha256-ffuXpyatcOoOdP1K2XI6lw+s+eem+iERv3cXPVSwGfA=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "3.9.1"
      "sha256-Q+d87WUSQPow0LB2oQoNIxdV5CTiQTRVhcboV7TyiHU=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "3.9.1"
      "sha256-oqGJmyqB+Od4XhuLRlLXKiRvgJnfIBCZ0PKOQoj28TE=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "3.9.1"
      "sha256-CR8Q3/JIBcOKIP04JT180SRDicXbvC7hRXEgpEcMB4M=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "3.9.1"
      "sha256-wgw7Wu6S6yWLxUk/ESQWGKFtGXJQ9rqNQvEHBZH6iqI=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "3.9.1"
      "sha256-yU/uAkbKf3SPn95p9cvj2O0RSzcsp1qnqrO9ABnPxLk=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "3.9.1"
      "sha256-g50Sm3Wf8M7OZQ9/BvpoK2dqLtS5C0R82y3Co+nNLCU=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "3.9.1"
      "sha256-hgpyRtMGz6d6ADL2/bWscmN6M6uFjH8XwRoy2NJ0YQI=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "3.9.1"
      "sha256-kRSX12eFLYSh8aUKCxXAMLjnCxVvOo2T9e91+CBuN70=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "3.9.1"
      "sha256-rVy85gIIFsAL4n/nFywHUmP9VK6eb3sz/SegqgJmyc8=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "3.9.1"
      "sha256-N6wC4mtFE1srJ+7u+G4Mjm1zMDVXjOlpu97/NP4c9rE=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "3.9.1"
      "sha256-mOE62hl0WGHRg6o368YOF5nM6CZn7W+/yo9yayY73SQ=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "3.9.1"
      "sha256-c/2eyJboTUmoIal//FIzmT9bhDmPIbb8UAZOQSWrf3o=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "3.9.1"
      "sha256-1PVjYeHN19OW+//JEa1Ajur3/5cke3r+f1vAbhheMjU=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "3.9.1"
      "sha256-WlekjujMgN8c9yxZIBYJ5ZTysGYDW8JmGqLDFplrOn0=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "3.9.1"
      "sha256-hkPWq/5oa6e3BrLRRJ8ckcpmu2LpobR0bjnm1mg5Re0=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "3.9.1"
      "sha256-Is5wBiRMLqWA27Xme/XuOzHQi9BpMCgkPavsy0Vw86E=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "3.9.1"
      "sha256-xWxrWdFfaFhAzTEK1yO5QX/jfxzbXiXGQoOG1HFjm7U=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "3.9.1"
      "sha256-l5w3XMEPSKxNYOuhqBYnYy+Pr8lsN49yH4rthpqaXJs=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "3.9.1"
      "sha256-l+lnOtnAb2W7NUXRqMy0M1lPjpZxclS0sZMWLmK0wQM=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "3.9.1"
      "sha256-3hvHxQhj4GX7cn9bsX9ilw6r+iVMqMA9ofnumyVcTZo=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "3.9.1"
      "sha256-63oh1tYj7hryoU6LCFqVqfbRxUsY1fMcKWcdIaPEW/M=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "3.9.1"
      "sha256-ob265TmtGf2zUetzLNti1jFDJ4lkk3crAzvjcBChBng=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "3.9.1"
      "sha256-onYuMOHp9/eYV376cBaaivfmnP9M2C/5iq+LxrLX7IA=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "3.9.1"
      "sha256-c+mMrlD1QrzEaUutFjwr6KSSR6TeMheEyRf28aFzWKw=";
}
