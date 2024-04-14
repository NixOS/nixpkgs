{ lib
, aiobotocore
, botocore
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, typing-extensions
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildTypesAiobotocorePackage = serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        inherit pname version hash;
      };

      build-system = [
        setuptools
      ];

      dependencies = [
        aiobotocore
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [
        typing-extensions
      ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [
        "types_aiobotocore_${toUnderscore serviceName}"
      ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer = buildTypesAiobotocorePackage "accessanalyzer" "2.11.2" "sha256-hUS1ZTj9CbC74Aiinmeh2BEQ2KymcqxuYVSeD12s5xg";

  types-aiobotocore-account = buildTypesAiobotocorePackage "account" "2.11.2" "sha256-XtL7R0UrgI/9rSxfNYbA0Lez+DiVyB7R+rhn49Nxerc=";

  types-aiobotocore-acm = buildTypesAiobotocorePackage "acm" "2.11.2" "sha256-vpE1GuvKFPsBf3rTk5V6B4ujFGaHE3wk9yN3j0sM0bo=";

  types-aiobotocore-acm-pca = buildTypesAiobotocorePackage "acm-pca" "2.11.2" "sha256-g9a2ad5hZonlKWGnLQchfT5CAgwqsvseeQBQemCSCQw=";

  types-aiobotocore-alexaforbusiness = buildTypesAiobotocorePackage "alexaforbusiness" "2.12.2" "sha256-ETgvEva3QPzS0jDxGwL8H+4skV+1/vwzLCyUT01gkLE=";

  types-aiobotocore-amp = buildTypesAiobotocorePackage "amp" "2.12.2" "sha256-1wUrSK52HpVAKdeWkGos2HwQaR2MaMae4OOVKicpp00=";

  types-aiobotocore-amplify = buildTypesAiobotocorePackage "amplify" "2.12.2" "sha256-b1J1tIlDcPuHkeZ978d3C2bLf6BSpq724BgkPaOAeXA=";

  types-aiobotocore-amplifybackend = buildTypesAiobotocorePackage "amplifybackend" "2.12.2" "sha256-4y3BHgzuyRQEefL4DpNyNXocvdD7KBcCbx4LfflIHY0=";

  types-aiobotocore-amplifyuibuilder = buildTypesAiobotocorePackage "amplifyuibuilder" "2.12.2" "sha256-RxSPzqzifUOkDYq9K8XCG2kVSB/wU14BeoTtFTPWuSk=";

  types-aiobotocore-apigateway = buildTypesAiobotocorePackage "apigateway" "2.12.2" "sha256-zTwooYIzXgPEIPG7gLoj2utBKGdqISuk1t7gOeBv3oQ=";

  types-aiobotocore-apigatewaymanagementapi = buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.12.2" "sha256-i2bFFhuWrRiL1pvEn604JMpLyyYXDQp5hUuUIXYbQeg=";

  types-aiobotocore-apigatewayv2 = buildTypesAiobotocorePackage "apigatewayv2" "2.12.2" "sha256-R8Kz/5CJBQ+O3uq6jNUr2Oz0LzoaJZXRw79XeL/M4Es=";

  types-aiobotocore-appconfig = buildTypesAiobotocorePackage "appconfig" "2.12.2" "sha256-Kae/vRF5DznNRmBOlVE6P9oDxJk+p6e/vWn+5rNdvGM=";

  types-aiobotocore-appconfigdata = buildTypesAiobotocorePackage "appconfigdata" "2.12.2" "sha256-uQ8PZVutdFpx15FFgFvT85XRXNsk8vQFIIBuh7e96Kw=";

  types-aiobotocore-appfabric = buildTypesAiobotocorePackage "appfabric" "2.12.2" "sha256-oy8/kIKXpuAzQGDr1EGDxTsj32IfjwQe/pGW2XtRQGA=";

  types-aiobotocore-appflow = buildTypesAiobotocorePackage "appflow" "2.12.2" "sha256-hZVdVOMtTi3uhvZSRw+72CDexb6ZjmhSOM96EO+SPpk=";

  types-aiobotocore-appintegrations = buildTypesAiobotocorePackage "appintegrations" "2.12.2" "sha256-jABV4S+JUPWlApzb00SXx759wwm9aVQg3H8t0HJGII4=";

  types-aiobotocore-application-autoscaling = buildTypesAiobotocorePackage "application-autoscaling" "2.12.2" "sha256-bF2+A9EJi8f9uNGe73oCaOSzakuU2QX9XxpAsAHEXLg=";

  types-aiobotocore-application-insights = buildTypesAiobotocorePackage "application-insights" "2.12.2" "sha256-3yWO7sXrNr6pkj5wZ7kLK5wwY9WKFILFVmuVPrqCjL4=";

  types-aiobotocore-applicationcostprofiler = buildTypesAiobotocorePackage "applicationcostprofiler" "2.12.2" "sha256-XAkJJTPkXbOsJrdBnCHcWJJgO2k58zKvBXFprLpLcj8=";

  types-aiobotocore-appmesh = buildTypesAiobotocorePackage "appmesh" "2.12.2" "sha256-R6BX6AYHflevTgiWD34F0k123kvFaXf/fzzjTa41EuU=";

  types-aiobotocore-apprunner = buildTypesAiobotocorePackage "apprunner" "2.12.2" "sha256-K0J1y4HYpWRxeHQE5QPxncrXbTxsS8VaQFOA+6C7vJI=";

  types-aiobotocore-appstream = buildTypesAiobotocorePackage "appstream" "2.12.2" "sha256-cTtqtK9K/HUFbuo7ZZJWOTB2pARECra2rcorHnyER18=";

  types-aiobotocore-appsync = buildTypesAiobotocorePackage "appsync" "2.12.2" "sha256-1JlMGgf8JXrTSXfKpKUx2L2lmDofdJ90VywCjWaiBlk=";

  types-aiobotocore-arc-zonal-shift = buildTypesAiobotocorePackage "arc-zonal-shift" "2.12.2" "sha256-V6KpOu/nmoniDstaa8NFB+04cAyRv8rRlJAbCb+Bwd0=";

  types-aiobotocore-athena = buildTypesAiobotocorePackage "athena" "2.12.2" "sha256-9/W5aC286MsgPQPQoPdzAi1ia0834rSw7vumRKVrpU0=";

  types-aiobotocore-auditmanager = buildTypesAiobotocorePackage "auditmanager" "2.12.2" "sha256-PjU0CQJSVgovPKk6iCz6OZCfXTfcMg6gVge+D2C0R5A=";

  types-aiobotocore-autoscaling = buildTypesAiobotocorePackage "autoscaling" "2.12.2" "sha256-VP2Hoh3HUYqNY00sEKEoqAx4QOVh9REBPpVlxxvuxs0=";

  types-aiobotocore-autoscaling-plans = buildTypesAiobotocorePackage "autoscaling-plans" "2.12.2" "sha256-61htbEFwvUYZymxPs4u+DCAuemVIwhplmsyRy79EPFk=";

  types-aiobotocore-backup = buildTypesAiobotocorePackage "backup" "2.12.2" "sha256-Wa7iDrphEu/lLO9jI+8DvY7zpk7bDqoKhT85cUhQRsQ=";

  types-aiobotocore-backup-gateway = buildTypesAiobotocorePackage "backup-gateway" "2.12.2" "sha256-31DD2XhktJJ5W4cfnzp7kq4I3O1cG02HNTTbHoKQ4c8=";

  types-aiobotocore-backupstorage = buildTypesAiobotocorePackage "backupstorage" "2.12.2" "sha256-d3C54F9epPGdP0f+FBcDc57D0z0lTlwthV8yWZqoZKo=";

  types-aiobotocore-batch = buildTypesAiobotocorePackage "batch" "2.12.2" "sha256-amRfVZeFXbCDXH5ZJkNxcn5LKrr3ImrnkCepdD+/BVA=";

  types-aiobotocore-billingconductor = buildTypesAiobotocorePackage "billingconductor" "2.12.2" "sha256-yGYcyqPGuEXNPRi9CrGvFgmuTquRVWV6Lvxpwz4vk88=";

  types-aiobotocore-braket = buildTypesAiobotocorePackage "braket" "2.12.2" "sha256-Xb5/W8moxLZ4EcWxtk06p0QO+RNq7m/cg3sr1s9EEjU=";

  types-aiobotocore-budgets = buildTypesAiobotocorePackage "budgets" "2.12.2" "sha256-uOtU24KgXLPXbHKEjGLPa5cklGSTv+ubgrK7BqdegcE=";

  types-aiobotocore-ce = buildTypesAiobotocorePackage "ce" "2.12.2" "sha256-8VE8GzjJpqSOhg12oVGRd9dvOgYHm46B3p11oYV/Hfk=";

  types-aiobotocore-chime = buildTypesAiobotocorePackage "chime" "2.12.2" "sha256-CsHu7oDQysHrteUU1fx875aqxah7tKcKcFVnjQRu56I=";

  types-aiobotocore-chime-sdk-identity = buildTypesAiobotocorePackage "chime-sdk-identity" "2.12.2" "sha256-LWcyeN84Ca91/FS3UYzE7wA0vqHQaYDRcsSvyjTQ/sw=";

  types-aiobotocore-chime-sdk-media-pipelines = buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.12.2" "sha256-+/pHe/DzMI3eWFHS8M588S0cuvAqrIUYidV3BXIUN3o=";

  types-aiobotocore-chime-sdk-meetings = buildTypesAiobotocorePackage "chime-sdk-meetings" "2.12.2" "sha256-ZTMMAi2fEHsFL7T81t4DiL1IOHJTkL8A7IG2g/v8ND0=";

  types-aiobotocore-chime-sdk-messaging = buildTypesAiobotocorePackage "chime-sdk-messaging" "2.12.2" "sha256-qt0JzJL9EwU1+Sh4CqMBiMNJIwI6YdmUvAvNBJv2oVw=";

  types-aiobotocore-chime-sdk-voice = buildTypesAiobotocorePackage "chime-sdk-voice" "2.12.2" "sha256-oFNY2oBIrj4OJATIkGeer00MDxqRf7Sh9whIm1Hr6Mk=";

  types-aiobotocore-cleanrooms = buildTypesAiobotocorePackage "cleanrooms" "2.12.2" "sha256-mG/fF8cgbI4xHdifOo4uXwCB0sLIeqHfDbFExRH1G1U=";

  types-aiobotocore-cloud9 = buildTypesAiobotocorePackage "cloud9" "2.12.2" "sha256-7Uw/ZVpdAu6TdwoqnoWFHOihoxTIyR9tMXawZ+FGZto=";

  types-aiobotocore-cloudcontrol = buildTypesAiobotocorePackage "cloudcontrol" "2.12.2" "sha256-L+FL66LIIGf2jeNis0fjnO8Y1tnxq2Wf2OOu6/dIyn8=";

  types-aiobotocore-clouddirectory = buildTypesAiobotocorePackage "clouddirectory" "2.12.2" "sha256-7wVsJpVN6dxNekF+Y41uS1gxXo11Ep6v7jigmKbtvv0=";

  types-aiobotocore-cloudformation = buildTypesAiobotocorePackage "cloudformation" "2.12.2" "sha256-gcrzYBBMfnzkwRkSxvAdJ85pNS2wrVCJSpC+gWV+wFs=";

  types-aiobotocore-cloudfront = buildTypesAiobotocorePackage "cloudfront" "2.12.2" "sha256-ZstNc2vk0Ri7O29YtxIdBnclbsWm/ZwlgRouDKO39VI=";

  types-aiobotocore-cloudhsm = buildTypesAiobotocorePackage "cloudhsm" "2.12.2" "sha256-12LqtV/KBWHO77VFEruNBvODUFZVnbWVFuf9xS9UZ7U=";

  types-aiobotocore-cloudhsmv2 = buildTypesAiobotocorePackage "cloudhsmv2" "2.12.2" "sha256-YBKCsDLOx9B+Eb5IhYcc84Nesn18ix3HON5u3lJTiuk=";

  types-aiobotocore-cloudsearch = buildTypesAiobotocorePackage "cloudsearch" "2.12.2" "sha256-iK0ZPBqilIPko8drXfVNrq2CY4GTxJkUTGfSE8X8izM=";

  types-aiobotocore-cloudsearchdomain = buildTypesAiobotocorePackage "cloudsearchdomain" "2.12.2" "sha256-kZ1tC8wgzThdUTb0ixjiL9tjCyi+YfGe/ET3tBAg9Wk=";

  types-aiobotocore-cloudtrail = buildTypesAiobotocorePackage "cloudtrail" "2.12.2" "sha256-WOWt4li3Gf3MzLWxyUQoQ9jOADSzVdInMeeSmMEHLt8=";

  types-aiobotocore-cloudtrail-data = buildTypesAiobotocorePackage "cloudtrail-data" "2.12.2" "sha256-YmYmwjPk+3NjZekJ0jkS5c4JqY1pl1ASPymSBbAurzc=";

  types-aiobotocore-cloudwatch = buildTypesAiobotocorePackage "cloudwatch" "2.12.2" "sha256-Ym7e9ZkfMll1YLAa/C+RwvHcbVwkY1foEmmlaL7qFcU=";

  types-aiobotocore-codeartifact = buildTypesAiobotocorePackage "codeartifact" "2.12.2" "sha256-GDySp3FuE0K/NZm4h/OxU7oYvDrGaL4g28ifzxdmTwg=";

  types-aiobotocore-codebuild = buildTypesAiobotocorePackage "codebuild" "2.12.2" "sha256-dLD5ovefqYEUxB0V+azNmfAbjKZ2K3ePjtCmPZpdt5I=";

  types-aiobotocore-codecatalyst = buildTypesAiobotocorePackage "codecatalyst" "2.12.2" "sha256-HtzCIUyhUvbK7dFGMFb472BiP9rvj7hmokOThk452uY=";

  types-aiobotocore-codecommit = buildTypesAiobotocorePackage "codecommit" "2.12.2" "sha256-XQyTXh8D/9O5YhsShvGckTfscT/teYLAhTgwmGTMd04=";

  types-aiobotocore-codedeploy = buildTypesAiobotocorePackage "codedeploy" "2.12.2" "sha256-7uJ44TJ8hWKhmvWAKyMAL/5kU/XIm+icrXbiw5dWTQU=";

  types-aiobotocore-codeguru-reviewer = buildTypesAiobotocorePackage "codeguru-reviewer" "2.12.2" "sha256-PIUP1kHTEq3yXoozKFDdN9C0jODMeSPIV387vnAAWuY=";

  types-aiobotocore-codeguru-security = buildTypesAiobotocorePackage "codeguru-security" "2.12.2" "sha256-VN45VIrBplN5UnPZtd6yDnSY1nj0YRVKdDejg0CsDPE=";

  types-aiobotocore-codeguruprofiler = buildTypesAiobotocorePackage "codeguruprofiler" "2.12.2" "sha256-+dI2LWqP1fmVMtQP247bo35yN0TxczXcPeCTSBNzMlM=";

  types-aiobotocore-codepipeline = buildTypesAiobotocorePackage "codepipeline" "2.12.2" "sha256-tlHbQTjTyZXJ2oPsOFepTn7BhNNaeLivDaqTw9dyte8=";

  types-aiobotocore-codestar = buildTypesAiobotocorePackage "codestar" "2.12.2" "sha256-ICX4Mm4legH/D6zw83mAuGtnHnO44Xsym7BtQusfJhE=";

  types-aiobotocore-codestar-connections = buildTypesAiobotocorePackage "codestar-connections" "2.12.2" "sha256-iL50uXFV9blh6MJjqQ8lEClO7PEPHNbao+ZBr7eIKVY=";

  types-aiobotocore-codestar-notifications = buildTypesAiobotocorePackage "codestar-notifications" "2.12.2" "sha256-6ugH1IdRuG9VSX3BYvCRSqOzCeNUJK654YTOX4uUCZc=";

  types-aiobotocore-cognito-identity = buildTypesAiobotocorePackage "cognito-identity" "2.12.2" "sha256-zxUOfY/mTVciiGZ17ZxiMIgAHR9RVKRKbR2L65uCK1I=";

  types-aiobotocore-cognito-idp = buildTypesAiobotocorePackage "cognito-idp" "2.12.2" "sha256-mKAbWofTXdBvsKxsLUso9zqjT3fr6Nn08wM5z04F/Wo=";

  types-aiobotocore-cognito-sync = buildTypesAiobotocorePackage "cognito-sync" "2.12.2" "sha256-riC2eCtEb0f32/hI593sbgLKEVf3jeWYO8LwsH0jvWk=";

  types-aiobotocore-comprehend = buildTypesAiobotocorePackage "comprehend" "2.12.2" "sha256-B/FxP4ia29VXS9urH6HfGvURM2Z7iOo8r8Zmp1Qwokc=";

  types-aiobotocore-comprehendmedical = buildTypesAiobotocorePackage "comprehendmedical" "2.12.2" "sha256-47wpqoxV3mrTdS+sHbD9mK/rwblLN3PK5eZQkx4eNBc=";

  types-aiobotocore-compute-optimizer = buildTypesAiobotocorePackage "compute-optimizer" "2.12.2" "sha256-1Gnw5TOkU5qGjTjHGaU2Lf5CpRWl/XHKtA/MlH8ZM48=";

  types-aiobotocore-config = buildTypesAiobotocorePackage "config" "2.12.2" "sha256-smum6KC3n5Des0dkQ0dpWPAmsNp0syMzWsaYzWWzz3M=";

  types-aiobotocore-connect = buildTypesAiobotocorePackage "connect" "2.12.2" "sha256-mlE5GRAkLUYXcywPzHvSjWLhzAZAwAEySK+xOmIGHxo=";

  types-aiobotocore-connect-contact-lens = buildTypesAiobotocorePackage "connect-contact-lens" "2.12.2" "sha256-YErrGkS78Ty8Hv95ofLKlYkL5MGmDnGjvHyDhNb7sc8=";

  types-aiobotocore-connectcampaigns = buildTypesAiobotocorePackage "connectcampaigns" "2.12.2" "sha256-TF5Skwtx581enCSHNCDzbdzaf4o8L+JQlcUSZ69hVIU=";

  types-aiobotocore-connectcases = buildTypesAiobotocorePackage "connectcases" "2.12.2" "sha256-nYzkrxhAGmkA1ZUPRxKmY6GWdG7io8yAfzo0D5znTmg=";

  types-aiobotocore-connectparticipant = buildTypesAiobotocorePackage "connectparticipant" "2.12.2" "sha256-ggAybqHfPYJLMPM8DZUQfmUdFCJEpETqWhJZMg68GzU=";

  types-aiobotocore-controltower = buildTypesAiobotocorePackage "controltower" "2.12.2" "sha256-HxUAm20R5OhvFz21KHOuZSYmnooU+SfAxCOqavnFZVA=";

  types-aiobotocore-cur = buildTypesAiobotocorePackage "cur" "2.12.2" "sha256-XK4+EvPDByogTh8En2xCUCeJsIV2OROE9bjHekO2hpU=";

  types-aiobotocore-customer-profiles = buildTypesAiobotocorePackage "customer-profiles" "2.12.2" "sha256-K89ciuIiaSS9i7BOkwc3u0Rvv5teMtvheDPTNTQr4Q8=";

  types-aiobotocore-databrew = buildTypesAiobotocorePackage "databrew" "2.12.2" "sha256-3vBQsZB8Mjvo/T2f6BdWUlXWnvkTfdiEcZhrlRuHr8g=";

  types-aiobotocore-dataexchange = buildTypesAiobotocorePackage "dataexchange" "2.12.2" "sha256-PzdVdYYXNoJ17y5X+0jtmtajfCP7JcgFlRMHoyYil1U=";

  types-aiobotocore-datapipeline = buildTypesAiobotocorePackage "datapipeline" "2.12.2" "sha256-cZj9t7Y4kNNS/l6JPihqd3ETu/9l9OrDIbn/PAvOcbc=";

  types-aiobotocore-datasync = buildTypesAiobotocorePackage "datasync" "2.12.2" "sha256-DGKdxsHlAEKb7USVM0FzFjsLLKwL5ZHEkhgjWSSgaAo=";

  types-aiobotocore-dax = buildTypesAiobotocorePackage "dax" "2.12.2" "sha256-lUX2JV7SQk39k/ri56pL9FMaPLIvII30vrOkcMaOuZ8=";

  types-aiobotocore-detective = buildTypesAiobotocorePackage "detective" "2.12.2" "sha256-9QYhpJGUFewUpSxd4KX+LSVBZLTJsNf8lkTaVBnMuX8=";

  types-aiobotocore-devicefarm = buildTypesAiobotocorePackage "devicefarm" "2.12.2" "sha256-v4wCi8MhkJCVscYqu0eD2dFwHcgZyFT6/Fl8IIRtmuY=";

  types-aiobotocore-devops-guru = buildTypesAiobotocorePackage "devops-guru" "2.12.2" "sha256-sQmBJuQOhXWd4Ed6S8eck7lmyuHYbTEfKXXLyP8Hi/c=";

  types-aiobotocore-directconnect = buildTypesAiobotocorePackage "directconnect" "2.12.2" "sha256-VjVTqn4vlu2IKAYN5sPX53ktjPQ7cxcW1SsS1IpyFe8=";

  types-aiobotocore-discovery = buildTypesAiobotocorePackage "discovery" "2.12.2" "sha256-rFqFq8++FeWKR/Q7c3Hp7e5595RKimPM8wC6wCnzU18=";

  types-aiobotocore-dlm = buildTypesAiobotocorePackage "dlm" "2.12.2" "sha256-16ctkHWUCptCGkqF2LV4aZbsQZPVcMCPnM4c4yYjr54=";

  types-aiobotocore-dms = buildTypesAiobotocorePackage "dms" "2.12.2" "sha256-thXJTCeLzlZ8AgffEcWabZexjcXj6tzUdKcVUO2h+as=";

  types-aiobotocore-docdb = buildTypesAiobotocorePackage "docdb" "2.12.2" "sha256-mEb8ojz1H2a8K5Vk+YM2eMM7E2yCNLkPFlkJDp6u0+c=";

  types-aiobotocore-docdb-elastic = buildTypesAiobotocorePackage "docdb-elastic" "2.12.2" "sha256-Gg8i3T7c9VyStoiO4IdvIpEkY4s9U0kdQkkrFToDGMo=";

  types-aiobotocore-drs = buildTypesAiobotocorePackage "drs" "2.12.2" "sha256-QjBZN5uD7c8TmAvDZkI0UmJttaryPmgp6jq3g3STIFA=";

  types-aiobotocore-ds = buildTypesAiobotocorePackage "ds" "2.12.2" "sha256-l8V/f2vcC6ztSaG+mjaYnWmOcsvbLogXE8tfIn+Fd8c=";

  types-aiobotocore-dynamodb = buildTypesAiobotocorePackage "dynamodb" "2.12.2" "sha256-dqfQ6X/jFhEWzkYf5Qt9++jk51OFNxv/7JCU4/YkGzw=";

  types-aiobotocore-dynamodbstreams = buildTypesAiobotocorePackage "dynamodbstreams" "2.12.2" "sha256-cay+xSJqhozKN5Qfm+ilYaOgL3wTDTrhWHHElD6Fq8o=";

  types-aiobotocore-ebs = buildTypesAiobotocorePackage "ebs" "2.12.2" "sha256-DnZe5HqyV+MUSR1O+XwgkJI4/xvS3KX2wKHxvmG3DL4=";

  types-aiobotocore-ec2 = buildTypesAiobotocorePackage "ec2" "2.12.2" "sha256-KEkPeWcpFdo58ti8edX3lX9KZEw/9raJysLiozI79kI=";

  types-aiobotocore-ec2-instance-connect = buildTypesAiobotocorePackage "ec2-instance-connect" "2.12.2" "sha256-Zy6EeikhwCsG8xZ/0QTOtECAYQFLn2fvdqwDob4Wq8U=";

  types-aiobotocore-ecr = buildTypesAiobotocorePackage "ecr" "2.12.2" "sha256-4SI+1chcCx/wArrTWqOn560EtfjIOaO92YyLM2PtMYI=";

  types-aiobotocore-ecr-public = buildTypesAiobotocorePackage "ecr-public" "2.12.2" "sha256-I6WPv0GmNp3aNrn7fnoSj660YojxsS/d+4qeHOzyZas=";

  types-aiobotocore-ecs = buildTypesAiobotocorePackage "ecs" "2.12.2" "sha256-aq0r9sYoVHccy7f3/WUtvWmbmeeGEu09nXU6nePf0gM=";

  types-aiobotocore-efs = buildTypesAiobotocorePackage "efs" "2.12.2" "sha256-ne7ORyHVEyZg5pGwS7Wypmd9ig6bAzfprvaJxEDz8qY=";

  types-aiobotocore-eks = buildTypesAiobotocorePackage "eks" "2.12.2" "sha256-SG2SbEjBjcr6wDYyo6Djt8seKHncW4XEY9HFQSbkg2E=";

  types-aiobotocore-elastic-inference = buildTypesAiobotocorePackage "elastic-inference" "2.12.2" "sha256-RzY7MJ3jV/DTylRkCKM74MOcDySSIwR1cxmHomW+a8s=";

  types-aiobotocore-elasticache = buildTypesAiobotocorePackage "elasticache" "2.12.2" "sha256-rMSkENOjnOtXZAMFXiWjhnFgTS2ihnp2U6FkuU4R88o=";

  types-aiobotocore-elasticbeanstalk = buildTypesAiobotocorePackage "elasticbeanstalk" "2.12.2" "sha256-HAqBCMCTLcHR0I2spr41JvwZpmWTWIPENLQBWAWJ/FY=";

  types-aiobotocore-elastictranscoder = buildTypesAiobotocorePackage "elastictranscoder" "2.12.2" "sha256-9XMdxrFLCbHQu7JeetSxwfUCo0eU16s5aA+xfwKxfiA=";

  types-aiobotocore-elb = buildTypesAiobotocorePackage "elb" "2.12.2" "sha256-QwVs2TATqPbkl90h6hJQlUPM/gpdog+oB11uggeeLDc=";

  types-aiobotocore-elbv2 = buildTypesAiobotocorePackage "elbv2" "2.12.2" "sha256-Jisv5FUAiuwxRVTYFqM51eBZjFpNWrWSZqZI66YozEg=";

  types-aiobotocore-emr = buildTypesAiobotocorePackage "emr" "2.12.2" "sha256-06W9wHe+Pt4tUNjBrXmy6LTmX1YijR1Y2yHb8RzUyHA=";

  types-aiobotocore-emr-containers = buildTypesAiobotocorePackage "emr-containers" "2.12.2" "sha256-vke/6UvOUwUSghwDnappBeZfafAWpsxg+H02LWZVQtE=";

  types-aiobotocore-emr-serverless = buildTypesAiobotocorePackage "emr-serverless" "2.12.2" "sha256-pFmgcNqLig3bK/5XruA05Uw0IrtYQhutl0XFLWU+TcA=";

  types-aiobotocore-entityresolution = buildTypesAiobotocorePackage "entityresolution" "2.12.2" "sha256-C9bhXADO2qhItCntG5OgtHoq5dTApS/dIuprUoeYQ2A=";

  types-aiobotocore-es = buildTypesAiobotocorePackage "es" "2.12.2" "sha256-EvdippGNEv14xe1mOxcIHy9/gfY5sH59ERMqrwOMigM=";

  types-aiobotocore-events = buildTypesAiobotocorePackage "events" "2.12.2" "sha256-XLXuheQPfEoobrVP9SRA7CWUzpU+02V25zenwDKi9x4=";

  types-aiobotocore-evidently = buildTypesAiobotocorePackage "evidently" "2.12.2" "sha256-VSCM6tR7hnykmKo9nzuhd0iaOmdoqjQ+pENJTvwUsoQ=";

  types-aiobotocore-finspace = buildTypesAiobotocorePackage "finspace" "2.12.2" "sha256-H/7wQxERVxA699UgLSfrfVSc/YOLmhhap0fhc+neacw=";

  types-aiobotocore-finspace-data = buildTypesAiobotocorePackage "finspace-data" "2.12.2" "sha256-fDxf0eZTu05m6C0HPr3iD9JnBHi7NLj2oGir0PQZuZQ=";

  types-aiobotocore-firehose = buildTypesAiobotocorePackage "firehose" "2.12.2" "sha256-CpXbwwSSkmX1gl83qXUcq1Hfm6qfPaaRQpZFQrjwCEs=";

  types-aiobotocore-fis = buildTypesAiobotocorePackage "fis" "2.12.2" "sha256-U6pTTt4vfu0BpLTY+DWHhdCXABg8wNgU1HQHMFA464Q=";

  types-aiobotocore-fms = buildTypesAiobotocorePackage "fms" "2.12.2" "sha256-U3ahHDszvVy7he1i+VHbByoINWLqulwjPwV0Q0JO2XA=";

  types-aiobotocore-forecast = buildTypesAiobotocorePackage "forecast" "2.12.2" "sha256-AF8zDThj/YYPydi+B53ovo7cu+GU7DIkeIMjxtRTOiY=";

  types-aiobotocore-forecastquery = buildTypesAiobotocorePackage "forecastquery" "2.12.2" "sha256-M53ScdaS31TmkhZVBjlohhOyBiWE99CZLPSmm/TfiOM=";

  types-aiobotocore-frauddetector = buildTypesAiobotocorePackage "frauddetector" "2.12.2" "sha256-9aFNev9n1+PBR9btvbtJLFuSe+Mx0lGl9kLpbjleUVE=";

  types-aiobotocore-fsx = buildTypesAiobotocorePackage "fsx" "2.12.2" "sha256-O8AuUIDjlOMos9RcJtlUP59HmdXXZs7G5dh48ACK3cQ=";

  types-aiobotocore-gamelift = buildTypesAiobotocorePackage "gamelift" "2.12.2" "sha256-VudsIk9Otibdq1Gnt7FDMLNuKWjGJNB9qpogv2A7upc=";

  types-aiobotocore-gamesparks = buildTypesAiobotocorePackage "gamesparks" "2.7.0" "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier = buildTypesAiobotocorePackage "glacier" "2.12.2" "sha256-GXPiOEfVPWd16turDWjgU37z9bvh+KXxkAKPyN5I+2g=";

  types-aiobotocore-globalaccelerator = buildTypesAiobotocorePackage "globalaccelerator" "2.12.2" "sha256-ra4VPjKNEmkOnilzwc50nUeo3VJJi2ifp4H4jJ0FFZw=";

  types-aiobotocore-glue = buildTypesAiobotocorePackage "glue" "2.12.2" "sha256-RA5Tp4hohM9U8UiFXLDu3iH5sb3GUaancnP7coPqk+Q=";

  types-aiobotocore-grafana = buildTypesAiobotocorePackage "grafana" "2.12.2" "sha256-WNzWOnpwikHH79QfPeFqOuA5RdYhiUHbqMhr/l14izc=";

  types-aiobotocore-greengrass = buildTypesAiobotocorePackage "greengrass" "2.12.2" "sha256-tAhvsGNrBcWOQNMX+WjERCCqQnrMdyBOwmFcfRwGd8A=";

  types-aiobotocore-greengrassv2 = buildTypesAiobotocorePackage "greengrassv2" "2.12.2" "sha256-Nk+9h2d1/E37wki3wkCQ+LlVvHbact12l/YmKw/eurM=";

  types-aiobotocore-groundstation = buildTypesAiobotocorePackage "groundstation" "2.12.2" "sha256-65idZ2V7v1sZdwqj2/RNqqbG/D8yH8jTA85GkY56bPs=";

  types-aiobotocore-guardduty = buildTypesAiobotocorePackage "guardduty" "2.12.2" "sha256-1ZxRFzTb2F/i75WCd9IB0JROlhSpDH6POQTvuwAMtcA=";

  types-aiobotocore-health = buildTypesAiobotocorePackage "health" "2.12.2" "sha256-ZEu6htVOjMnS8hpRfJ5+PDpg6WOFpIrYR+Wwd0J64x4=";

  types-aiobotocore-healthlake = buildTypesAiobotocorePackage "healthlake" "2.12.2" "sha256-IE85NtxaiDBqwxM3/85T/1JWakgYbXXT7xXX8tE8U7g=";

  types-aiobotocore-honeycode = buildTypesAiobotocorePackage "honeycode" "2.12.2" "sha256-bPhhNG/nTkXsKzK/bP76WHdwn1QViqvxSEIhkHqbMjk=";

  types-aiobotocore-iam = buildTypesAiobotocorePackage "iam" "2.12.2" "sha256-4DgTLBlfpvUDfvVlu4MZcY/H1mtoPhyZJBOIv8xVAlQ=";

  types-aiobotocore-identitystore = buildTypesAiobotocorePackage "identitystore" "2.12.2" "sha256-LbU0IB9LD7sVNVIzoUF1xwqKvT75IedKN42M7W6e13I=";

  types-aiobotocore-imagebuilder = buildTypesAiobotocorePackage "imagebuilder" "2.12.2" "sha256-RVdWetHqv+oF5gJhKcJirocyeI96FhLI07qlhI9apkk=";

  types-aiobotocore-importexport = buildTypesAiobotocorePackage "importexport" "2.12.2" "sha256-N0Dri5WpxxsgHy58blWVs7UNrvcwOVVXowbqkLV6T50=";

  types-aiobotocore-inspector = buildTypesAiobotocorePackage "inspector" "2.12.2" "sha256-DakehZs/UE6Bh7b/ivTmue3uQclx9/1HBZn4DPZb+4s=";

  types-aiobotocore-inspector2 = buildTypesAiobotocorePackage "inspector2" "2.12.2" "sha256-HUmiN5ZAV3l+LO+DtT7L/nFIuTv0xaAAm/tIhBF83C4=";

  types-aiobotocore-internetmonitor = buildTypesAiobotocorePackage "internetmonitor" "2.12.2" "sha256-dEulJ3YmtaODVZiiz1zQfO5meNnDdlPILgihuvJYsPI=";

  types-aiobotocore-iot = buildTypesAiobotocorePackage "iot" "2.12.2" "sha256-wXSOfVVJFe+yQwKwvVBxuyVq029qyYgNHowHQ63kLi0=";

  types-aiobotocore-iot-data = buildTypesAiobotocorePackage "iot-data" "2.12.2" "sha256-4xmQ41ts7lyTHyOhutEx6jKZvjiI6bKb40H056kmu6Q=";

  types-aiobotocore-iot-jobs-data = buildTypesAiobotocorePackage "iot-jobs-data" "2.12.2" "sha256-CNmF9yts8zcZGoWDRpodIkMcho8eGeWTPAOYx2dH8/A=";

  types-aiobotocore-iot-roborunner = buildTypesAiobotocorePackage "iot-roborunner" "2.12.2" "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices = buildTypesAiobotocorePackage "iot1click-devices" "2.12.2" "sha256-zMH/2TjygyROUjWDwsozbyoCMWquSbaq0e2ImVM53GI=";

  types-aiobotocore-iot1click-projects = buildTypesAiobotocorePackage "iot1click-projects" "2.12.2" "sha256-4tjJAmrGkY0kkAPncSknqC33lgxSUMu8ClCfFpKVF1w=";

  types-aiobotocore-iotanalytics = buildTypesAiobotocorePackage "iotanalytics" "2.12.2" "sha256-r3zLmpdZq1gtGZCcleuIslDB0Bgk8HzVAzl2yOgFIOk=";

  types-aiobotocore-iotdeviceadvisor = buildTypesAiobotocorePackage "iotdeviceadvisor" "2.12.2" "sha256-/Rux1JInDSnVbYs/jlCoVEiCf3ANsBc/agBlXasCQgA=";

  types-aiobotocore-iotevents = buildTypesAiobotocorePackage "iotevents" "2.12.2" "sha256-3s0jtHPsvhIcUpPk3z2BtTaQZR6J+RDIwQtxTexXdLE=";

  types-aiobotocore-iotevents-data = buildTypesAiobotocorePackage "iotevents-data" "2.12.2" "sha256-bK10y+aLN8N5wslhdu52XMLGgNH9LO0ep32uX9CuZzM=";

  types-aiobotocore-iotfleethub = buildTypesAiobotocorePackage "iotfleethub" "2.12.2" "sha256-j9dcSxRWODy3TkJ8Hr4ujG2aAFUW1+MtWgdMFVqB+Y4=";

  types-aiobotocore-iotfleetwise = buildTypesAiobotocorePackage "iotfleetwise" "2.12.2" "sha256-pLPrleqesg452YXkEI2m1dUnxRB+f6yIIbMXygYUoig=";

  types-aiobotocore-iotsecuretunneling = buildTypesAiobotocorePackage "iotsecuretunneling" "2.12.2" "sha256-YgO57irLn0Phrp87Oy3LwUSChpcnoRrvVa0dDHnXdws=";

  types-aiobotocore-iotsitewise = buildTypesAiobotocorePackage "iotsitewise" "2.12.2" "sha256-oKg/Ij1VkKJicAAMPhlK4ZgvrWIObKzEv4J5ghVYKGE=";

  types-aiobotocore-iotthingsgraph = buildTypesAiobotocorePackage "iotthingsgraph" "2.12.2" "sha256-j+Yly3Drp2OZp+VfbgO9xlya4+bkPW7RTojtSMl22xs=";

  types-aiobotocore-iottwinmaker = buildTypesAiobotocorePackage "iottwinmaker" "2.12.2" "sha256-yuAwmATSv9rJiZoDawNsRjzi2cIvWTdYMtlCE29AXac=";

  types-aiobotocore-iotwireless = buildTypesAiobotocorePackage "iotwireless" "2.12.2" "sha256-coGGYQQ9IEfZird3b7CUN3I4i0yTx/BUxUEAOfzy6hY=";

  types-aiobotocore-ivs = buildTypesAiobotocorePackage "ivs" "2.12.2" "sha256-2qeniJPHq7UuN1XZjjboRPk+6LWKvnJejkAqDwsfpMU=";

  types-aiobotocore-ivs-realtime = buildTypesAiobotocorePackage "ivs-realtime" "2.12.2" "sha256-mml/atoPlJc01/SNtsdJflIVdD7quHUeDDvuBFIdzJk=";

  types-aiobotocore-ivschat = buildTypesAiobotocorePackage "ivschat" "2.12.2" "sha256-+thrqQWsysaEtI2QRHE9h5b829AAstr3bO6FzhM/r5o=";

  types-aiobotocore-kafka = buildTypesAiobotocorePackage "kafka" "2.12.2" "sha256-3aP7XxRoIkAYpXT+VCWv/l9fahZqD6cwt3sp68PaZss=";

  types-aiobotocore-kafkaconnect = buildTypesAiobotocorePackage "kafkaconnect" "2.12.2" "sha256-FIdudAIjDPnUrfNWTr9p4JHk6X5OSDEIezge10kooGk=";

  types-aiobotocore-kendra = buildTypesAiobotocorePackage "kendra" "2.12.2" "sha256-37DjQeqoBv5/ee7Py7atxMEpFcO+MHVVlvq1SZvG+0Y=";

  types-aiobotocore-kendra-ranking = buildTypesAiobotocorePackage "kendra-ranking" "2.12.2" "sha256-BbmM46/3RVK3Xu7Ld6HyOpK9kMS979AVLINCITUVEqQ=";

  types-aiobotocore-keyspaces = buildTypesAiobotocorePackage "keyspaces" "2.12.2" "sha256-xQ4ApKTPpVi5ZHG/jJJh+TH7ySN9SQPVyx0Hb8QZD3U=";

  types-aiobotocore-kinesis = buildTypesAiobotocorePackage "kinesis" "2.12.2" "sha256-2ECUqeEf9H4gTBVH3Q8KkDkyBjRyHvQB/tv2ETI5A64=";

  types-aiobotocore-kinesis-video-archived-media = buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.12.2" "sha256-pUcXz9U0/y5XmNh4aaeyD9h3NmUAXO4HOOF9OKXn2v8=";

  types-aiobotocore-kinesis-video-media = buildTypesAiobotocorePackage "kinesis-video-media" "2.12.2" "sha256-F6tEzbBT76/Ha2LWE7UGo2CGyGQujlkVo26p7IeghHI=";

  types-aiobotocore-kinesis-video-signaling = buildTypesAiobotocorePackage "kinesis-video-signaling" "2.12.2" "sha256-iGBCoN/MO7T5rEByU7XIwsDaU4D0RlhdzFPuuGNNkgg=";

  types-aiobotocore-kinesis-video-webrtc-storage = buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.12.2" "sha256-8ROMjFVkx8g6rBHLgJOZEFs4kYAPm6Y9AqhArMnyisA=";

  types-aiobotocore-kinesisanalytics = buildTypesAiobotocorePackage "kinesisanalytics" "2.12.2" "sha256-fd/GkiYXB3jnZFaKfBmK/ErRRKG1jkp+yZzyMJUDh2I=";

  types-aiobotocore-kinesisanalyticsv2 = buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.12.2" "sha256-dxdItvqPNHryoFGzhammRZeiCL0u86DuHbSgDspUa0g=";

  types-aiobotocore-kinesisvideo = buildTypesAiobotocorePackage "kinesisvideo" "2.12.2" "sha256-H77H0tQF8D1bBDcBOvmPjjqV8xnhTXfCErW5b1dAedk=";

  types-aiobotocore-kms = buildTypesAiobotocorePackage "kms" "2.12.2" "sha256-JR9YWdUr/WSctGZDpn8B5/uSRR8H6w5TZHLhH0XyNmM=";

  types-aiobotocore-lakeformation = buildTypesAiobotocorePackage "lakeformation" "2.12.2" "sha256-fTD+ih2A2gSvIFodfLl6XtVHEARmuljXkw+wBIybNs0=";

  types-aiobotocore-lambda = buildTypesAiobotocorePackage "lambda" "2.12.2" "sha256-K5GWmLHKP7F/wbXyP6lxInabLdeboYjp8VUws5lqqQI=";

  types-aiobotocore-lex-models = buildTypesAiobotocorePackage "lex-models" "2.12.2" "sha256-yoCuE7N9r+dQTnI4Tpahk+XkgJF0En9KYv90fzZlgx8=";

  types-aiobotocore-lex-runtime = buildTypesAiobotocorePackage "lex-runtime" "2.12.2" "sha256-++3WGlOYNSNvshExKyfOf406n8vWpmWOitsMYOH+ymk=";

  types-aiobotocore-lexv2-models = buildTypesAiobotocorePackage "lexv2-models" "2.12.2" "sha256-hM3ssVD+OBs4a9lUqKSYvEDNPV4712q2LsliGZGimsM=";

  types-aiobotocore-lexv2-runtime = buildTypesAiobotocorePackage "lexv2-runtime" "2.12.2" "sha256-S9iJOMKtbc3XBmiFc1pxDgDpmRKd8HYvma2utVFytUg=";

  types-aiobotocore-license-manager = buildTypesAiobotocorePackage "license-manager" "2.12.2" "sha256-+Tc2zrfnK2SYYCIVhpHV5BlRa6CMpmNyHKmtf+HWv60=";

  types-aiobotocore-license-manager-linux-subscriptions = buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.12.2" "sha256-5I7HN5+6y/RkOBq/P7hsg85ubH40V6x+fw/yLOvm1Vc=";

  types-aiobotocore-license-manager-user-subscriptions = buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.12.2" "sha256-0BEGqnjne1Mf/Ad6wOI0TfuS7UeQD8zZSAKjGWX4ZD8=";

  types-aiobotocore-lightsail = buildTypesAiobotocorePackage "lightsail" "2.12.2" "sha256-qOI5ZpNcUZyYDLOeQbEIieIrJC2R2AjhwOm5p6MALq0=";

  types-aiobotocore-location = buildTypesAiobotocorePackage "location" "2.12.2" "sha256-rbkuoTPBuR64rzxKY6vPSOsVEP6ySPEBESX/0FvObqA=";

  types-aiobotocore-logs = buildTypesAiobotocorePackage "logs" "2.12.2" "sha256-dwW58A1MI8wY8f2dk10aZENeOraN9pK2fdFfwA/Kijs=";

  types-aiobotocore-lookoutequipment = buildTypesAiobotocorePackage "lookoutequipment" "2.12.2" "sha256-e+wxPC7W6fHY+Mpyu/XEvhfrANtZCEODzndm8XmkNrg=";

  types-aiobotocore-lookoutmetrics = buildTypesAiobotocorePackage "lookoutmetrics" "2.12.2" "sha256-CyYKju2+7R1yOQegIP9pBhbYzbRCO4/NDT4rVfdSryE=";

  types-aiobotocore-lookoutvision = buildTypesAiobotocorePackage "lookoutvision" "2.12.2" "sha256-qy3k2l2vo8hcJkKZZAgIcv8Hia7KqnJPrfkRLtz0osw=";

  types-aiobotocore-m2 = buildTypesAiobotocorePackage "m2" "2.12.2" "sha256-J/Wet0L6i9dEmYbe4hZZB+Ri0xOFzvwjDdwklOCMI64=";

  types-aiobotocore-machinelearning = buildTypesAiobotocorePackage "machinelearning" "2.12.2" "sha256-qhH4cJyZG6u0Bv+c6IbNhRJRXKSvuazgTuX1bYD2nLQ=";

  types-aiobotocore-macie = buildTypesAiobotocorePackage "macie" "2.7.0" "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 = buildTypesAiobotocorePackage "macie2" "2.12.2" "sha256-nSBhjRTIz5Y4oVk3QFdT5fjQns5joLSOTOYpN3NLkx0=";

  types-aiobotocore-managedblockchain = buildTypesAiobotocorePackage "managedblockchain" "2.12.2" "sha256-1EvGSxhSYFcBQaNBL1S/0CxPYZzR32dHwqZmWPL4XzI=";

  types-aiobotocore-managedblockchain-query = buildTypesAiobotocorePackage "managedblockchain-query" "2.12.2" "sha256-9huoAvQVb7xCdB2LYwRZJUeaHsNlPKoLW7YpMd/yRIk=";

  types-aiobotocore-marketplace-catalog = buildTypesAiobotocorePackage "marketplace-catalog" "2.12.2" "sha256-BfXESvCJxAH2FTlRQnLW9jd5bNcp3++/wRP+3seU3KM=";

  types-aiobotocore-marketplace-entitlement = buildTypesAiobotocorePackage "marketplace-entitlement" "2.12.2" "sha256-57CTCjocq/Lqfa7jpxtUuf4SwKl5sOPR2vfXXTSA0A8=";

  types-aiobotocore-marketplacecommerceanalytics = buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.12.2" "sha256-xOi59tLCjwveFz3/vHiF8nr0+Vihcz24j9Ht29I9UNA=";

  types-aiobotocore-mediaconnect = buildTypesAiobotocorePackage "mediaconnect" "2.12.2" "sha256-CBBOJFlYbG1ox9IveURJo3HVahX9qxXddQUBUD6R1fI=";

  types-aiobotocore-mediaconvert = buildTypesAiobotocorePackage "mediaconvert" "2.12.2" "sha256-UVnDCv5MB2F0CiOo8nQ+hPbAeD31wMl/uc9qgYw+new=";

  types-aiobotocore-medialive = buildTypesAiobotocorePackage "medialive" "2.12.2" "sha256-kxgheN0PKRA8gv0yiTf5Muazu9TKrd8UzZL5+2ay2NA=";

  types-aiobotocore-mediapackage = buildTypesAiobotocorePackage "mediapackage" "2.12.2" "sha256-PjPr4HeUb/VplY/hmF8gOa3RWzNGLX508to8dYKAIio=";

  types-aiobotocore-mediapackage-vod = buildTypesAiobotocorePackage "mediapackage-vod" "2.12.2" "sha256-2kP8Gx1QCnaewG0UHwk+5NTzAN6tP2NYiwGY1m5V2Og=";

  types-aiobotocore-mediapackagev2 = buildTypesAiobotocorePackage "mediapackagev2" "2.12.2" "sha256-BW3c4xoh1Mv0uo+NCSg6Xl1bUhFmXFSc402/WO/8hv0=";

  types-aiobotocore-mediastore = buildTypesAiobotocorePackage "mediastore" "2.12.2" "sha256-BAt31NLW9YbSCBEGBwOJzgOUGtHoiobe4b3wWv6dSRM=";

  types-aiobotocore-mediastore-data = buildTypesAiobotocorePackage "mediastore-data" "2.12.2" "sha256-mgSCGs0bIO6DcEh2ltDFyqpm0+8SPhy2DvKr/vep6mo=";

  types-aiobotocore-mediatailor = buildTypesAiobotocorePackage "mediatailor" "2.12.2" "sha256-9yNQOmGY4cnGo+0tv9cC9WX/I9Hrp8FFrRFSXCt3Eag=";

  types-aiobotocore-medical-imaging = buildTypesAiobotocorePackage "medical-imaging" "2.12.2" "sha256-94w2Q6SBAUSl4K4xF44EsmTL58V8CioP5B/iCVGhPwI=";

  types-aiobotocore-memorydb = buildTypesAiobotocorePackage "memorydb" "2.12.2" "sha256-goKbZrz221ckjnKb2csaRJoVkYbUEXPxPi6Rx29Jg5Y=";

  types-aiobotocore-meteringmarketplace = buildTypesAiobotocorePackage "meteringmarketplace" "2.12.2" "sha256-Qs0ISYY5cIxJW1c5XQVgSk7IIB8QFZlFMrKXSek0d7A=";

  types-aiobotocore-mgh = buildTypesAiobotocorePackage "mgh" "2.12.2" "sha256-iiy8qAvbvcB1DBZ2f/ebg7SPXfFWHYu96aQh/rwLqsg=";

  types-aiobotocore-mgn = buildTypesAiobotocorePackage "mgn" "2.12.2" "sha256-y6keS7tgcHC1oZi3gcNqecz20xmOIpZ0jvIOR84hRsE=";

  types-aiobotocore-migration-hub-refactor-spaces = buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.12.2" "sha256-RGGGLmSXLT+xfzMX9AtF8TaL4Q3DrAivDTer/rHUmho=";

  types-aiobotocore-migrationhub-config = buildTypesAiobotocorePackage "migrationhub-config" "2.12.2" "sha256-FggcsS518/ruQpaqZg8hcc3pHABTMGpOcUA5WzsJGZo=";

  types-aiobotocore-migrationhuborchestrator = buildTypesAiobotocorePackage "migrationhuborchestrator" "2.12.2" "sha256-a1Z+p31ejt3THonN3++G9QyK8zLTLuRiDmeUMtOUKOI=";

  types-aiobotocore-migrationhubstrategy = buildTypesAiobotocorePackage "migrationhubstrategy" "2.12.2" "sha256-DlN06USadfepXgXOXwHOTumC3uf1k1m88hkVGUjbmT8=";

  types-aiobotocore-mobile = buildTypesAiobotocorePackage "mobile" "2.12.2" "sha256-7ZRRkspQmH7nUA2mEIvB7+i9J5NfJ99CBvdZK/oOjnI=";

  types-aiobotocore-mq = buildTypesAiobotocorePackage "mq" "2.12.2" "sha256-RzO3j+nLqUUdmu7TeL30JnfmWYZhBL19m9QoiMYIUsQ=";

  types-aiobotocore-mturk = buildTypesAiobotocorePackage "mturk" "2.12.2" "sha256-YmoUT3LtPMbhltnX1ogHg1EU5FlYzRIrDh+Hsa9hcpo=";

  types-aiobotocore-mwaa = buildTypesAiobotocorePackage "mwaa" "2.12.2" "sha256-pGDsqWgWVodxKE1cFO16+7nxmrZth2ytht8Y1Kl41zM=";

  types-aiobotocore-neptune = buildTypesAiobotocorePackage "neptune" "2.12.2" "sha256-Ng8w4ofKoRDVzBqAz39bWUaKf8irRCBiNcG+ZS9ydSc=";

  types-aiobotocore-network-firewall = buildTypesAiobotocorePackage "network-firewall" "2.12.2" "sha256-olp26SNu18zkvokRVQqGD/+gLbgdE0KuHjG43GU9sc8=";

  types-aiobotocore-networkmanager = buildTypesAiobotocorePackage "networkmanager" "2.12.2" "sha256-QEseMxRJhjpzBl4JA1DmD50jMOGoFwCxsO+b13oG5YE=";

  types-aiobotocore-nimble = buildTypesAiobotocorePackage "nimble" "2.12.2" "sha256-Ipd5zzhasx6RAg1Z6V+iGkfVujPRBNvqWVpfgMid09U=";

  types-aiobotocore-oam = buildTypesAiobotocorePackage "oam" "2.12.2" "sha256-VDqLVHzV6y3SXi4AXmXeNid1oJozldN13jzThgH8pDo=";

  types-aiobotocore-omics = buildTypesAiobotocorePackage "omics" "2.12.2" "sha256-bLW7ZSgjt+wPU7pY01Kkbvw5ad6KPntini/dWojv/zw=";

  types-aiobotocore-opensearch = buildTypesAiobotocorePackage "opensearch" "2.12.2" "sha256-NKKYyM7AFn9zJue4z6LisAv+1h159BTAmoUyMy/XiWg=";

  types-aiobotocore-opensearchserverless = buildTypesAiobotocorePackage "opensearchserverless" "2.12.2" "sha256-ngxBovkRBXpJfX5D1Heuyf1jpfAxSK0S56gtZFQI0Ec=";

  types-aiobotocore-opsworks = buildTypesAiobotocorePackage "opsworks" "2.12.2" "sha256-EPR1oeh2FbDwhloUoUJzB3ukU/5FPBC1pxfTxItFafg=";

  types-aiobotocore-opsworkscm = buildTypesAiobotocorePackage "opsworkscm" "2.12.2" "sha256-h7T4cjY3Ym/P7Rk0PlZvN6EVdLR1PgFLR923X9DOGdc=";

  types-aiobotocore-organizations = buildTypesAiobotocorePackage "organizations" "2.12.2" "sha256-jJyJpQLEdrv3q82z3R/YKzx+02Q9j4JmtJfEWQkpmAw=";

  types-aiobotocore-osis = buildTypesAiobotocorePackage "osis" "2.12.2" "sha256-M4lVp6DWFyrwzlpwxiqC5bMLcO/j4a85HxSnVq0/iiQ=";

  types-aiobotocore-outposts = buildTypesAiobotocorePackage "outposts" "2.12.2" "sha256-0MV1PfsZECgq+u61/8yOUC1HPze623VfAJIm62JiFyM=";

  types-aiobotocore-panorama = buildTypesAiobotocorePackage "panorama" "2.12.2" "sha256-wN1Zgw88oK4vyNJJVUZ1cAeGcBhMiFAQ7Ct05kGMT38=";

  types-aiobotocore-payment-cryptography = buildTypesAiobotocorePackage "payment-cryptography" "2.12.2" "sha256-3ZMmQhutDZ37xywyMrtGdhhNfmwS9Q63cf0tuzyjPAk=";

  types-aiobotocore-payment-cryptography-data = buildTypesAiobotocorePackage "payment-cryptography-data" "2.12.2" "sha256-Ix8Hze5f5J9NbyU/FnoWC1XWKQo5NttwSohHA7QSHt8=";

  types-aiobotocore-personalize = buildTypesAiobotocorePackage "personalize" "2.12.2" "sha256-AwT3/QK4AUEPQRBIQ5stFfDXjfgCixVu7WWqwL81/7w=";

  types-aiobotocore-personalize-events = buildTypesAiobotocorePackage "personalize-events" "2.12.2" "sha256-b5CyfUzzMisQC5E2XC0nCdj1SCMRZJKA4H5V4bkEET4=";

  types-aiobotocore-personalize-runtime = buildTypesAiobotocorePackage "personalize-runtime" "2.12.2" "sha256-tWcc0H0S7lZgHdj42iDroqu9W5S9ZGtQ+L3EnU6Z4rM=";

  types-aiobotocore-pi = buildTypesAiobotocorePackage "pi" "2.12.2" "sha256-MehRBiTkYLTSynpwIQJB3+Q/DgwOUQMwfXlYDi3w5WI=";

  types-aiobotocore-pinpoint = buildTypesAiobotocorePackage "pinpoint" "2.12.2" "sha256-MzenXuejYdjqnKDhyp2NdVJMrUQ3j5EGhkB81e2PBQM=";

  types-aiobotocore-pinpoint-email = buildTypesAiobotocorePackage "pinpoint-email" "2.12.2" "sha256-PEWYZIcR8N+eYRC1YorF2+OGRA2YLCRwD53Q13AHx8Y=";

  types-aiobotocore-pinpoint-sms-voice = buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.12.2" "sha256-F+Lqf2IOPco9411tcLeECO/NDOIg8CjJGKnhxGOPlY8=";

  types-aiobotocore-pinpoint-sms-voice-v2 = buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.12.2" "sha256-UIxVqV5IFVFWUdjgac4vNzkYbq/jGyu7r8VlQUG4DhM=";

  types-aiobotocore-pipes = buildTypesAiobotocorePackage "pipes" "2.12.2" "sha256-SytI03HrvJQNxh4+08BOQSAuc9L/lJTlfArTXQlKJxE=";

  types-aiobotocore-polly = buildTypesAiobotocorePackage "polly" "2.12.2" "sha256-OW4mbtGlnSZ/XI5XV2V7HWT40AU3KE/QJ1cJL8i5hfE=";

  types-aiobotocore-pricing = buildTypesAiobotocorePackage "pricing" "2.12.2" "sha256-29DE4QWR6vxAlXXg9ogWIw2m0tiPOXNbCJHf3auMap8=";

  types-aiobotocore-privatenetworks = buildTypesAiobotocorePackage "privatenetworks" "2.12.2" "sha256-/Hcb08LOIy1gcYjrI9F4R1v7pFW0iukp2cV2iy9W4oA=";

  types-aiobotocore-proton = buildTypesAiobotocorePackage "proton" "2.12.2" "sha256-Eja/Y797YeMFleClVOKK0QA3O1uBK/ynAFuxdrC1JhY=";

  types-aiobotocore-qldb = buildTypesAiobotocorePackage "qldb" "2.12.2" "sha256-ztgDsbYexUlzCji5Hxa8+SfU1Gs1K903cJmLkcfgOLQ=";

  types-aiobotocore-qldb-session = buildTypesAiobotocorePackage "qldb-session" "2.12.2" "sha256-ZM5XLZJkcNwVlj4txCAGZNVzLrUWuXBWUhyPvrxgABM=";

  types-aiobotocore-quicksight = buildTypesAiobotocorePackage "quicksight" "2.12.2" "sha256-PJ5Wlfl5mFgGF3OaBUp76KN7CNMsoRwZcrzGAVzXJ8A=";

  types-aiobotocore-ram = buildTypesAiobotocorePackage "ram" "2.12.2" "sha256-idMuIdxSXJqeyflzO3U9LXOr7etwdpb8Vun+KK+W0xA=";

  types-aiobotocore-rbin = buildTypesAiobotocorePackage "rbin" "2.12.2" "sha256-7QZihv5XMyGhGxcN32F0NzexQRTAtNEOYKaR68B1QV0=";

  types-aiobotocore-rds = buildTypesAiobotocorePackage "rds" "2.12.2" "sha256-Mrckkfb/G9OC+wuQOw0Au4SGI/F/Exqj5g7c9/uiw3s=";

  types-aiobotocore-rds-data = buildTypesAiobotocorePackage "rds-data" "2.12.2" "sha256-N+ff5ZOUu6iAIPTow4Y4vgscHtDc4k0qH3STVdAiKks=";

  types-aiobotocore-redshift = buildTypesAiobotocorePackage "redshift" "2.12.2" "sha256-TDcemfXL2G8wUMmyHV2LXfCO76bhKNwxbSeemtG7wKI=";

  types-aiobotocore-redshift-data = buildTypesAiobotocorePackage "redshift-data" "2.12.2" "sha256-Fmy1QYmj2wPMc1lS17gfVUS7Q30gV7gg48CBGLAIUZU=";

  types-aiobotocore-redshift-serverless = buildTypesAiobotocorePackage "redshift-serverless" "2.12.2" "sha256-3OY8OSz/OfwnQ56flsy78O4UY3U0Eq8VwOlZE5Pgu70=";

  types-aiobotocore-rekognition = buildTypesAiobotocorePackage "rekognition" "2.12.2" "sha256-MWehv4SxIzGn9BCdX4VGxRQTB1/87TxQSUjhgNYneT4=";

  types-aiobotocore-resiliencehub = buildTypesAiobotocorePackage "resiliencehub" "2.12.2" "sha256-XfYtSqUPSp2GgkEWspls5rIg9v1iYqQwSBzMbJF2RwY=";

  types-aiobotocore-resource-explorer-2 = buildTypesAiobotocorePackage "resource-explorer-2" "2.12.2" "sha256-NHCI46o5Em6PaT4J5Po3sMxrDurILGPNB/yrr2+z5ew=";

  types-aiobotocore-resource-groups = buildTypesAiobotocorePackage "resource-groups" "2.12.2" "sha256-/BMPSJlAJnXuyXzFJ3C4P/q+3CyQez3DE1d/n/qs4jI=";

  types-aiobotocore-resourcegroupstaggingapi = buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.12.2" "sha256-6T9Jy6fquOMR1SdyuCePlKaRMawsPNVBCC8ikL7yBlI=";

  types-aiobotocore-robomaker = buildTypesAiobotocorePackage "robomaker" "2.12.2" "sha256-rhMxrUYyh4LNvdBzeU2weQ5tYeB4m2GEey1ThTGLe2c=";

  types-aiobotocore-rolesanywhere = buildTypesAiobotocorePackage "rolesanywhere" "2.12.2" "sha256-NDVe7y2eLBuZEWsutZyyV5d58Rhoijf13YMays3Jdx0=";

  types-aiobotocore-route53 = buildTypesAiobotocorePackage "route53" "2.12.2" "sha256-LcR0vMKdWfXZbsBM5L45JvJDqTc+s+hd65FhOsVRvfw=";

  types-aiobotocore-route53-recovery-cluster = buildTypesAiobotocorePackage "route53-recovery-cluster" "2.12.2" "sha256-BhLBcFThFx7l6CuOzNJkZ8YN6HVRICpolGmJ3+HTjPM=";

  types-aiobotocore-route53-recovery-control-config = buildTypesAiobotocorePackage "route53-recovery-control-config" "2.12.2" "sha256-OT7GjKAT5MF/ztxoz7JFavOLYF+tHMlLSP2INKfY1Ws=";

  types-aiobotocore-route53-recovery-readiness = buildTypesAiobotocorePackage "route53-recovery-readiness" "2.12.2" "sha256-2tKAml1Q02CzYKbXSb1cX0J+sikRaO4w7xs5ezIrbxc=";

  types-aiobotocore-route53domains = buildTypesAiobotocorePackage "route53domains" "2.12.2" "sha256-b4mDaB4eri2iZEplPdxsiOxdZ5SKlx81kMCk5U4rRyo=";

  types-aiobotocore-route53resolver = buildTypesAiobotocorePackage "route53resolver" "2.12.2" "sha256-1594OFyWF906H7vJlvz/eZ/OkEIHYiEyZJi2k8svyjM=";

  types-aiobotocore-rum = buildTypesAiobotocorePackage "rum" "2.12.2" "sha256-A6ZMbQv2b70onH8ZHuRPl4L0SE8WPuUNF8lePZfvp/I=";

  types-aiobotocore-s3 = buildTypesAiobotocorePackage "s3" "2.12.2" "sha256-YsEzOxrhFa6HTVZ1k+D8SaQxphXSzcUGTFFBYi5a1HY=";

  types-aiobotocore-s3control = buildTypesAiobotocorePackage "s3control" "2.12.2" "sha256-kK255cm6UdK+8SR2tSs+SgJwx8OVqMEwFIUJ7uLW8iA=";

  types-aiobotocore-s3outposts = buildTypesAiobotocorePackage "s3outposts" "2.12.2" "sha256-7Y9wXe9L66Hs2teCYHN2bxgXmIrs6HhLoq9NxQ4T1lg=";

  types-aiobotocore-sagemaker = buildTypesAiobotocorePackage "sagemaker" "2.12.2" "sha256-wRKIngMjGLGyvfJ7xpiaNGpj+oQCctpWFXVX9ZKglwQ=";

  types-aiobotocore-sagemaker-a2i-runtime = buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.12.2" "sha256-zi0aXoD/YxXwpC2YVDKI0WvK9G4TlDiCEfUP09m3SWw=";

  types-aiobotocore-sagemaker-edge = buildTypesAiobotocorePackage "sagemaker-edge" "2.12.2" "sha256-HfyLVC2GSnzMDSyWkpN1WmhK8sJcMGmmiuToRURV7yM=";

  types-aiobotocore-sagemaker-featurestore-runtime = buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.12.2" "sha256-nubZcHUhuSDawDXKhwTggDr+mxBdx+uXRIWX9JJDAx4=";

  types-aiobotocore-sagemaker-geospatial = buildTypesAiobotocorePackage "sagemaker-geospatial" "2.12.2" "sha256-FwEx2BwIqI/Sc8+ZZA+qnpjxVvyXHlMamVhrjilq0cw=";

  types-aiobotocore-sagemaker-metrics = buildTypesAiobotocorePackage "sagemaker-metrics" "2.12.2" "sha256-1g2W/ODx2N1kXM6av2FkdFOcT/IqfY1CtHcOzXJJmqY=";

  types-aiobotocore-sagemaker-runtime = buildTypesAiobotocorePackage "sagemaker-runtime" "2.12.2" "sha256-wDXnZmydXVGjnNezooiP7TxxXmRdTfY7OamqQG7mmhU=";

  types-aiobotocore-savingsplans = buildTypesAiobotocorePackage "savingsplans" "2.12.2" "sha256-FHXr+j9LmefGjeimSGVbuKgWYhxOrASsogWkxQE2N58=";

  types-aiobotocore-scheduler = buildTypesAiobotocorePackage "scheduler" "2.12.2" "sha256-IHy8VN021UBpYMsef5b1tSu9zhfRgXaosLDX9pUhgsE=";

  types-aiobotocore-schemas = buildTypesAiobotocorePackage "schemas" "2.12.2" "sha256-LAJBYjaOc8rhJNrAzOJReTYBmRpeba4VJfszDVuFA4g=";

  types-aiobotocore-sdb = buildTypesAiobotocorePackage "sdb" "2.12.2" "sha256-wpVdLd1n8TXjzwCHL+JbyUZaYdsekT/R3KjY+ToISp4=";

  types-aiobotocore-secretsmanager = buildTypesAiobotocorePackage "secretsmanager" "2.12.2" "sha256-9rHzNW9xD2k2fIBuOzICqyNdUQB1K3ml5PVAn6OuG08=";

  types-aiobotocore-securityhub = buildTypesAiobotocorePackage "securityhub" "2.12.2" "sha256-97io+U0ZTfzH5AuInHtc4YXNG4l+pkxjnL+MeZl627o=";

  types-aiobotocore-securitylake = buildTypesAiobotocorePackage "securitylake" "2.12.2" "sha256-1bWfvpDEShVTcF7sEpz7KYXNMv3fwUhOtd8ICNx3bZk=";

  types-aiobotocore-serverlessrepo = buildTypesAiobotocorePackage "serverlessrepo" "2.12.2" "sha256-5bKh3PMr8uKvJGoNl26qGyKJsOBXWQDDKTgBKIC6Glc=";

  types-aiobotocore-service-quotas = buildTypesAiobotocorePackage "service-quotas" "2.12.2" "sha256-EwrP4t5TFOeSQ9xMv+1H0L3qEDepwQ0/7JnS4aKbFk4=";

  types-aiobotocore-servicecatalog = buildTypesAiobotocorePackage "servicecatalog" "2.12.2" "sha256-tgIcA1ZtkzMQdksGEqnjkpwfGnpG0tmkrlnjKsArvAE=";

  types-aiobotocore-servicecatalog-appregistry = buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.12.2" "sha256-oLn2o+EwsjWOgIuuNCi898EHI53Y3e04MxoyWkEHzKg=";

  types-aiobotocore-servicediscovery = buildTypesAiobotocorePackage "servicediscovery" "2.12.2" "sha256-D40N1DoI6xT5Dz9VsnK39CDoUCVtblV5eHESUecxxEI=";

  types-aiobotocore-ses = buildTypesAiobotocorePackage "ses" "2.12.2" "sha256-SIj1/+vgxsHv59HH/kc+iqTCbI+sYLbhaMnAt5WwifY=";

  types-aiobotocore-sesv2 = buildTypesAiobotocorePackage "sesv2" "2.12.2" "sha256-HpMrPG7PYyfy5F4kLZsMbKsexqXziVf2wNPPBbglmcs=";

  types-aiobotocore-shield = buildTypesAiobotocorePackage "shield" "2.12.2" "sha256-WALZ9EVDvifxiOlcYhZXuajORsbC4GpeD/LVA0yuPBA=";

  types-aiobotocore-signer = buildTypesAiobotocorePackage "signer" "2.12.2" "sha256-3D18EK5Q+zHmA8WLXLaenswIw+HF2b4tZCY4TZA4sHs=";

  types-aiobotocore-simspaceweaver = buildTypesAiobotocorePackage "simspaceweaver" "2.12.2" "sha256-id5LKXq/3hsvZPblmBNGzRaLFG57VfL9feXtCUKSDHg=";

  types-aiobotocore-sms = buildTypesAiobotocorePackage "sms" "2.12.2" "sha256-7sc4gD4rfbubwDQI2u/XvF4cNslnFGcN94h6uB5cHp4=";

  types-aiobotocore-sms-voice = buildTypesAiobotocorePackage "sms-voice" "2.12.2" "sha256-nS+LiEvDP4IZMduhrbO16oTtFSp423/Y2SlT6Cj+CL8=";

  types-aiobotocore-snow-device-management = buildTypesAiobotocorePackage "snow-device-management" "2.12.2" "sha256-CUkRt31gGK08kxPuMfP0T1XLOJOQPJUG3Oxis8p3/vQ=";

  types-aiobotocore-snowball = buildTypesAiobotocorePackage "snowball" "2.12.2" "sha256-Wprhzjwh4mKqFizDcfUewEo8ho0lKaVItqO6tOIOV+4=";

  types-aiobotocore-sns = buildTypesAiobotocorePackage "sns" "2.12.2" "sha256-Yser4nTXIfYQ2cAEOVAEdJ2du/imthk4RA0nkZpBfxU=";

  types-aiobotocore-sqs = buildTypesAiobotocorePackage "sqs" "2.12.2" "sha256-MYJjaAoEG33xQy2hWmb45KC/MjAbdiNz+C+Pn/4USo0=";

  types-aiobotocore-ssm = buildTypesAiobotocorePackage "ssm" "2.12.2" "sha256-QZRMWMC87WL7HwNoGkIKBusPVMKEN3AyoKFVQ0bA4VU=";

  types-aiobotocore-ssm-contacts = buildTypesAiobotocorePackage "ssm-contacts" "2.12.2" "sha256-m2zC26dCphVlPxShHJv6ZvAzRL1TJ1t0/yywxPQ7k1w=";

  types-aiobotocore-ssm-incidents = buildTypesAiobotocorePackage "ssm-incidents" "2.12.2" "sha256-tcFiqjyp0yvftb6p6AS6uD1/stAp6BgjjssCfL5Wcq4=";

  types-aiobotocore-ssm-sap = buildTypesAiobotocorePackage "ssm-sap" "2.12.2" "sha256-oWGPSPLr7OCZ/F+crxqFJtT2yjPQfKO4ZExVmEmuHts=";

  types-aiobotocore-sso = buildTypesAiobotocorePackage "sso" "2.12.2" "sha256-C4Ne19U9yQNvdkv1169JaQP42W8tbRY7HH2ffNc6flU=";

  types-aiobotocore-sso-admin = buildTypesAiobotocorePackage "sso-admin" "2.12.2" "sha256-0e/wU+WmMsyd2eR28U32Nb2/GGkcIx34fznW8vK1vjI=";

  types-aiobotocore-sso-oidc = buildTypesAiobotocorePackage "sso-oidc" "2.12.2" "sha256-MKctbFIixCUNjPgMaVS44qGeVw97kSjNzv27Lz0wdH4=";

  types-aiobotocore-stepfunctions = buildTypesAiobotocorePackage "stepfunctions" "2.12.2" "sha256-/uSY/rT99prkan1Jdzmrqfrtd+IY4lTCjhEoVDd/5qw=";

  types-aiobotocore-storagegateway = buildTypesAiobotocorePackage "storagegateway" "2.12.2" "sha256-4imdUKHgiR8MdfP9d+mfUSvX/BGML6OyhFZSoqfvUyE=";

  types-aiobotocore-sts = buildTypesAiobotocorePackage "sts" "2.12.2" "sha256-ZjWt8aMpB7rm5RiN0wu0Rtf0GmB0pyQheulIdiESYJw=";

  types-aiobotocore-support = buildTypesAiobotocorePackage "support" "2.12.2" "sha256-m9gE+WrA3hGyFsce9yuQ2Rc1T+C34CV3qee1cUh5iqg=";

  types-aiobotocore-support-app = buildTypesAiobotocorePackage "support-app" "2.12.2" "sha256-sDFQII+lci1rt4IR3nfHphO2LSv0QER1incTUdRhUO0=";

  types-aiobotocore-swf = buildTypesAiobotocorePackage "swf" "2.12.2" "sha256-4kM9IuYO9AGhppvigtrSfCpbLem4MxNijEPIxLO6bgA=";

  types-aiobotocore-synthetics = buildTypesAiobotocorePackage "synthetics" "2.12.2" "sha256-8sewpC5P4bkL3k2U+6SpbeJ++2T0KhymCyqsSWHvgx8=";

  types-aiobotocore-textract = buildTypesAiobotocorePackage "textract" "2.12.2" "sha256-Y3ts/v4pdmX2KFm9ZWcFhPyPQOhjXZ73jNUbDso90Tk=";

  types-aiobotocore-timestream-query = buildTypesAiobotocorePackage "timestream-query" "2.12.2" "sha256-F1Du1aia/Q1bo+F7YJRpSkU2/8lHG3KObHUZdZ/z2I8=";

  types-aiobotocore-timestream-write = buildTypesAiobotocorePackage "timestream-write" "2.12.2" "sha256-OhisvyX9nBqBEfYdXNPeEF5jURFOvoXN9YxJDkKDOqc=";

  types-aiobotocore-tnb = buildTypesAiobotocorePackage "tnb" "2.12.2" "sha256-W1luQ356xiJA7RKG57DNVaY5YZBvYv4AlFavdTXxng8=";

  types-aiobotocore-transcribe = buildTypesAiobotocorePackage "transcribe" "2.12.2" "sha256-uNACYs85jyW97SE+U58JexWrFUVOCNLkCuHRc+ZkFZ4=";

  types-aiobotocore-transfer = buildTypesAiobotocorePackage "transfer" "2.12.2" "sha256-d72xsEhJn6D8OujIxP9xObjPyxRPmcIdnly+ZwvEzCw=";

  types-aiobotocore-translate = buildTypesAiobotocorePackage "translate" "2.12.2" "sha256-rQdiVuH8W7kxYSD5AxGvQraNJf6acmN+F9Rr2NP5sKw=";

  types-aiobotocore-verifiedpermissions = buildTypesAiobotocorePackage "verifiedpermissions" "2.12.2" "sha256-MIF51gNhXzNcm1lSLwpfvFm0TIeFmj+MEEIPT/FRO/Y=";

  types-aiobotocore-voice-id = buildTypesAiobotocorePackage "voice-id" "2.12.2" "sha256-lnifYdOU3hJly0lUJFkfBaNFyyCQESz2ef3F0BrMSCE=";

  types-aiobotocore-vpc-lattice = buildTypesAiobotocorePackage "vpc-lattice" "2.12.2" "sha256-JJrunGOEf96BmIr1A2I3p4g6tHwvc6AZn7iWEGemahI=";

  types-aiobotocore-waf = buildTypesAiobotocorePackage "waf" "2.12.2" "sha256-nBxBriQLUlmURSWHrmFMVa31dUOVjzFTBFhwxhrgdmc=";

  types-aiobotocore-waf-regional = buildTypesAiobotocorePackage "waf-regional" "2.12.2" "sha256-bntzQDr6j23lp46Fd4awX/w8W0dUQ9Z7mH5jc8r7NKo=";

  types-aiobotocore-wafv2 = buildTypesAiobotocorePackage "wafv2" "2.12.2" "sha256-fsIxp6khnfxMQyy0+LqyCyjP110Ik/L5zafE13JOxtY=";

  types-aiobotocore-wellarchitected = buildTypesAiobotocorePackage "wellarchitected" "2.12.2" "sha256-6E4hpBgAH01FExto7Q9voThCNZu0s9VPw/J2Bar34O8=";

  types-aiobotocore-wisdom = buildTypesAiobotocorePackage "wisdom" "2.12.2" "sha256-skK8YWujl1RShe9LQoE0FXsNiQynycMoruFdlDxDFBk=";

  types-aiobotocore-workdocs = buildTypesAiobotocorePackage "workdocs" "2.12.2" "sha256-H1qRcCqRhnPtfIXxEpZ5IQTJ0LxEnY0oayxnVXVB9rA=";

  types-aiobotocore-worklink = buildTypesAiobotocorePackage "worklink" "2.12.2" "sha256-lnMETLwtvtRSIPqecuc3JbDKFuUn/FaWyiLBB3+T5x4=";

  types-aiobotocore-workmail = buildTypesAiobotocorePackage "workmail" "2.12.2" "sha256-CbeOMFYa6IGuXX8ALLIHa8LSNMivuNebW8uw1ee1omo=";

  types-aiobotocore-workmailmessageflow = buildTypesAiobotocorePackage "workmailmessageflow" "2.12.2" "sha256-6fN0swm3VSw3ppDe+oVmWGFxuFYGtIDScSdGKCMEBlQ=";

  types-aiobotocore-workspaces = buildTypesAiobotocorePackage "workspaces" "2.12.2" "sha256-tAD9BBHyoSD26ifWTJoCucsYILkZ4VQxJ87p/KOV/2s=";

  types-aiobotocore-workspaces-web = buildTypesAiobotocorePackage "workspaces-web" "2.12.2" "sha256-tFwMHDFAoiL2gGU26JoxJfWSFIqP/Co48Ugs9IS6o/s=";

  types-aiobotocore-xray = buildTypesAiobotocorePackage "xray" "2.12.2" "sha256-B9B7xBTCcAYAcOhlyxevtmAnpVyRgDgBz9GpcD7ZMhU=";
}
