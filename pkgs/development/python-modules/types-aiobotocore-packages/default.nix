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

      nativeBuildInputs = [
        setuptools
      ];

      propagatedBuildInputs = [
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

  types-aiobotocore-alexaforbusiness = buildTypesAiobotocorePackage "alexaforbusiness" "2.12.1" "sha256-3x/hagYKcLpkQcl2xs5E1BK86pBexCPEI9jXoapaupk=";

  types-aiobotocore-amp = buildTypesAiobotocorePackage "amp" "2.12.1" "sha256-nqfw8mMje6HZo6ZiOin1Ki3i/ldnxwcestf+7AYvfRo=";

  types-aiobotocore-amplify = buildTypesAiobotocorePackage "amplify" "2.12.1" "sha256-mI4T75e4J0jUy3zyhRQTf2BK1G0+dvAIteGUOeoTphg=";

  types-aiobotocore-amplifybackend = buildTypesAiobotocorePackage "amplifybackend" "2.12.1" "sha256-flDA+ENgxiTyUQYlv7B4Rj8avu+7/8HcDCm5gy1boRQ=";

  types-aiobotocore-amplifyuibuilder = buildTypesAiobotocorePackage "amplifyuibuilder" "2.12.1" "sha256-BqRPND+LfrMfs7VffO1GB9qk5WQgqPV+jCpwMp2351k=";

  types-aiobotocore-apigateway = buildTypesAiobotocorePackage "apigateway" "2.12.1" "sha256-jYW4DedcNBTVplVdOfj6JV8zvY00b6xp8kB22ug5ejU=";

  types-aiobotocore-apigatewaymanagementapi = buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.12.1" "sha256-y/vhZTSQVANxxNWkbcupu3JjhA1CYwcoY9FjDZMarEk=";

  types-aiobotocore-apigatewayv2 = buildTypesAiobotocorePackage "apigatewayv2" "2.12.1" "sha256-ZPqN6GmWiB9WOE5iiO86SFHoIF8kj0vKRbWvUupZEbQ=";

  types-aiobotocore-appconfig = buildTypesAiobotocorePackage "appconfig" "2.12.1" "sha256-icbJT3C4cHYWVDYDeQWmnFTLaxb1YgOwIOWHasrSEU4=";

  types-aiobotocore-appconfigdata = buildTypesAiobotocorePackage "appconfigdata" "2.12.1" "sha256-Uc+eRBHVAfztcsXcGbwjJi4JRM6kQtXkIqhuLGhjwL0=";

  types-aiobotocore-appfabric = buildTypesAiobotocorePackage "appfabric" "2.12.1" "sha256-AlrHEE9y9q4D5q5M6YiWLTHdbsRBf5i+ifIGcuS8F38=";

  types-aiobotocore-appflow = buildTypesAiobotocorePackage "appflow" "2.12.1" "sha256-Jg2v0ygeP6UIvNrnyuilzbeCpKSs8L6yGTlh6aAMXko=";

  types-aiobotocore-appintegrations = buildTypesAiobotocorePackage "appintegrations" "2.12.1" "sha256-x6EuJVZJl/mw7wXfJP5djkVKsZ9rxSlAMynlmIeYf7c=";

  types-aiobotocore-application-autoscaling = buildTypesAiobotocorePackage "application-autoscaling" "2.12.1" "sha256-ZLgLJAGtiMUhWWXz2GxwOaxn9CzRh2lWTvhvOrzUDq4=";

  types-aiobotocore-application-insights = buildTypesAiobotocorePackage "application-insights" "2.12.1" "sha256-p96BagoCjYHXqnCQqVMLlwNT6hlkIOhLFmXcXQKZsIM=";

  types-aiobotocore-applicationcostprofiler = buildTypesAiobotocorePackage "applicationcostprofiler" "2.12.1" "sha256-bDuo8+w6NbWh7vFV488kuS/by+Bb8m3KvKqFtQRJbVY=";

  types-aiobotocore-appmesh = buildTypesAiobotocorePackage "appmesh" "2.12.1" "sha256-IXg7ZyW6rnpb2XycRLnMcihim4pYIC0iiQlQf07mesY=";

  types-aiobotocore-apprunner = buildTypesAiobotocorePackage "apprunner" "2.12.1" "sha256-bSEzv5bkO6L0VGrdAmsSeH62wjQWnJu34lGSsa5U/J0=";

  types-aiobotocore-appstream = buildTypesAiobotocorePackage "appstream" "2.12.1" "sha256-pMnJ6CcqhhBGpPG4sPsJUqcCohFZPHQ4nZbM82WhFQg=";

  types-aiobotocore-appsync = buildTypesAiobotocorePackage "appsync" "2.12.1" "sha256-8IyLcQLUg/t/WodMhJkrUnTYOVR5PmkjDtILnzYEqKM=";

  types-aiobotocore-arc-zonal-shift = buildTypesAiobotocorePackage "arc-zonal-shift" "2.12.1" "sha256-8HP5cQS7p7QyncnccISZHOPIYwWEyMUIz0OEiwoZ0OQ=";

  types-aiobotocore-athena = buildTypesAiobotocorePackage "athena" "2.12.1" "sha256-9wlWv7qFWj/bnLIEH2wXGHG0IYvPdEIolDyh9xJsY6I=";

  types-aiobotocore-auditmanager = buildTypesAiobotocorePackage "auditmanager" "2.12.1" "sha256-/IYKAlDmq/+5jsMcnwmhVV+OMvWP4IcMdrtZ3ocy0ls=";

  types-aiobotocore-autoscaling = buildTypesAiobotocorePackage "autoscaling" "2.12.1" "sha256-pJZDPqRXSKlDYd57vfJdgbaszKhyvONsgRhHxT7PO3s=";

  types-aiobotocore-autoscaling-plans = buildTypesAiobotocorePackage "autoscaling-plans" "2.12.1" "sha256-VqO8b8JQX1OzvgHnZZCC6l3a73Ren2b2GphClJBZc/c=";

  types-aiobotocore-backup = buildTypesAiobotocorePackage "backup" "2.12.1" "sha256-UMP61m/gcHfc5JUtAoEAIfxdbjntqL7HubUuTb4AfwI=";

  types-aiobotocore-backup-gateway = buildTypesAiobotocorePackage "backup-gateway" "2.12.1" "sha256-bxXM19C5beGNvKV0bXpnU43e3h8UmFJpXc1kmsbeelw=";

  types-aiobotocore-backupstorage = buildTypesAiobotocorePackage "backupstorage" "2.12.1" "sha256-+y3Xqw/KJqcSC7VMwjN+FZN/MLt0E/UISk+CNRN0lTI=";

  types-aiobotocore-batch = buildTypesAiobotocorePackage "batch" "2.12.1" "sha256-cX2aVftGdhLDfY3bSSIiFnOV0EPfmlcwrSG7ad+On1g=";

  types-aiobotocore-billingconductor = buildTypesAiobotocorePackage "billingconductor" "2.12.1" "sha256-GROhwMYXYrYTChJVlE/MN/EZ0NzOHeSXAfiIuHJG9u8=";

  types-aiobotocore-braket = buildTypesAiobotocorePackage "braket" "2.12.1" "sha256-d9oj+mAHxXapK+756DrglrqlYTOlZQtkFdbh+Ipanqc=";

  types-aiobotocore-budgets = buildTypesAiobotocorePackage "budgets" "2.12.1" "sha256-kCXjo49wwgdVjbI45A+JV0gQbb7FxqSi2rqa41XgrbI=";

  types-aiobotocore-ce = buildTypesAiobotocorePackage "ce" "2.12.1" "sha256-RNGUxIvjKqJvOQ3CUjfJWHGD76wUqfev43aCU5Z+5Dg=";

  types-aiobotocore-chime = buildTypesAiobotocorePackage "chime" "2.12.1" "sha256-/EHroPbg5w45i8vqpzLHf8ZpzIWbOLLwwAbP/MZvDyI=";

  types-aiobotocore-chime-sdk-identity = buildTypesAiobotocorePackage "chime-sdk-identity" "2.12.1" "sha256-yZbk3/p11XA6y57z58ShBpYzbgmZaqXKFaSjRNLIHAs=";

  types-aiobotocore-chime-sdk-media-pipelines = buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.12.1" "sha256-A45a8+rGxkkF+qMNWQOwp3keTnVqitC+T+1cXfpjh4s=";

  types-aiobotocore-chime-sdk-meetings = buildTypesAiobotocorePackage "chime-sdk-meetings" "2.12.1" "sha256-CBOz1xzJF7502CCcdbVPTnC5lRgDHsRCRQjDhvUJQks=";

  types-aiobotocore-chime-sdk-messaging = buildTypesAiobotocorePackage "chime-sdk-messaging" "2.12.1" "sha256-IzhApCA/D73+LPyxILQDrKTRABG3kgyVobNdY0L065M=";

  types-aiobotocore-chime-sdk-voice = buildTypesAiobotocorePackage "chime-sdk-voice" "2.12.1" "sha256-o+QL/ujJrHtggWUOTXgE5/EcE5Dsx4EYAOrRbLAV6qM=";

  types-aiobotocore-cleanrooms = buildTypesAiobotocorePackage "cleanrooms" "2.12.1" "sha256-haTOrvbpW3sM2cj4hhb1higAs/CcBM07bKbeSP29ox0=";

  types-aiobotocore-cloud9 = buildTypesAiobotocorePackage "cloud9" "2.12.1" "sha256-lB7ETrEcEcUN0Wo0v5jfHS/7deB+RigE7QAsRtCm34s=";

  types-aiobotocore-cloudcontrol = buildTypesAiobotocorePackage "cloudcontrol" "2.12.1" "sha256-9wQePNZU01EZ0HsEri+NhyqbovxKvrq1Ym2X6ZjmpgQ=";

  types-aiobotocore-clouddirectory = buildTypesAiobotocorePackage "clouddirectory" "2.12.1" "sha256-tcapX1pGlYT5I9psU/lhq+ltsYJzhJA8ECopImTBNG8=";

  types-aiobotocore-cloudformation = buildTypesAiobotocorePackage "cloudformation" "2.12.1" "sha256-ZDPwZIVtYGjMVYGhwRqHhDgQuGRMPm9nDSf3yXyHDig=";

  types-aiobotocore-cloudfront = buildTypesAiobotocorePackage "cloudfront" "2.12.1" "sha256-1SkPaujxS66tXJ7d37AOF5fWJfm6NMMFs3BdCzvFQ18=";

  types-aiobotocore-cloudhsm = buildTypesAiobotocorePackage "cloudhsm" "2.12.1" "sha256-h/ukCEJa/sU2c54Yt0JccYHUkk57A48hBZy0dixo37Q=";

  types-aiobotocore-cloudhsmv2 = buildTypesAiobotocorePackage "cloudhsmv2" "2.12.1" "sha256-ErBwA+z2JvT5xfvoTzsIAVPU8tU08sphFXGw1g3f4yQ=";

  types-aiobotocore-cloudsearch = buildTypesAiobotocorePackage "cloudsearch" "2.12.1" "sha256-1olJgbAOkbh9vXli4pcwwJoi1THWtfU8oz9YCj6Ukes=";

  types-aiobotocore-cloudsearchdomain = buildTypesAiobotocorePackage "cloudsearchdomain" "2.12.1" "sha256-aGTQp3cmL7ZWu4g17Rrk5rmiJ4aQRmPk54AGSWkhFGs=";

  types-aiobotocore-cloudtrail = buildTypesAiobotocorePackage "cloudtrail" "2.12.1" "sha256-bM3LaR0mBX7i7hUB4maK7exCplszTtN+I5EllNdXy64=";

  types-aiobotocore-cloudtrail-data = buildTypesAiobotocorePackage "cloudtrail-data" "2.12.1" "sha256-GOm6+wQGXOmJJa7Thw1QwEh7qsfGrmlphlR9jbWVRwI=";

  types-aiobotocore-cloudwatch = buildTypesAiobotocorePackage "cloudwatch" "2.12.1" "sha256-7HPW7wBHzEz3Wf+ExWt0EuLGyMenZLKitxg1vRRLvXg=";

  types-aiobotocore-codeartifact = buildTypesAiobotocorePackage "codeartifact" "2.12.1" "sha256-vbVK79R9VPVVtpqvzhdRiVkLBhfRZgFYcoH7asbaE0c=";

  types-aiobotocore-codebuild = buildTypesAiobotocorePackage "codebuild" "2.12.1" "sha256-eXPqgX5MD/aIBxIQjHqyP4I0FJ2l+AHnoiq6RofKY4Q=";

  types-aiobotocore-codecatalyst = buildTypesAiobotocorePackage "codecatalyst" "2.12.1" "sha256-xu7zEVV3AX9ygsYzTjyp1WcA5fEndCu6yCMsCuDnYOo=";

  types-aiobotocore-codecommit = buildTypesAiobotocorePackage "codecommit" "2.12.1" "sha256-IshGyh7RTJDbmcjJ/t1SoeZKd7GnsRrr/kZAXpLZQXY=";

  types-aiobotocore-codedeploy = buildTypesAiobotocorePackage "codedeploy" "2.12.1" "sha256-1ess+WyiHaejghvuESxCHBu7XmGoR9uA3fL21WzhBPs=";

  types-aiobotocore-codeguru-reviewer = buildTypesAiobotocorePackage "codeguru-reviewer" "2.12.1" "sha256-o9WfffjQPMU8pgUtQFrj7+CyP87rvalF1qxTTZp/UgM=";

  types-aiobotocore-codeguru-security = buildTypesAiobotocorePackage "codeguru-security" "2.12.1" "sha256-RfKsb90lP57S6kyvfrFGampEGGHr1czQ/+49Oox0rEI=";

  types-aiobotocore-codeguruprofiler = buildTypesAiobotocorePackage "codeguruprofiler" "2.12.1" "sha256-1AkpcKCrwHIJHO9cFIyZrizSbNeLcjhRbTlvgDz6RJ4=";

  types-aiobotocore-codepipeline = buildTypesAiobotocorePackage "codepipeline" "2.12.1" "sha256-0qNifbqbtK/XNo9un7snezMTBw5ED08UxZnHgVJj4HU=";

  types-aiobotocore-codestar = buildTypesAiobotocorePackage "codestar" "2.12.1" "sha256-Du4dvdfqQjtRwnomiqtV+T3z65PjomCAkgl1vMAsZ2A=";

  types-aiobotocore-codestar-connections = buildTypesAiobotocorePackage "codestar-connections" "2.12.1" "sha256-wHiMhzwCMPgrtZ650BAsZvgldAzGR6kjnHIQh0B8scA=";

  types-aiobotocore-codestar-notifications = buildTypesAiobotocorePackage "codestar-notifications" "2.12.1" "sha256-rOKutC1NJS55XJ5sWks++sylGHLOwo1OElz+uZXMhQo=";

  types-aiobotocore-cognito-identity = buildTypesAiobotocorePackage "cognito-identity" "2.12.1" "sha256-aBwQC4hoUaZWbICP74+vy3xocFGHWfB4B5hb+JwMKeA=";

  types-aiobotocore-cognito-idp = buildTypesAiobotocorePackage "cognito-idp" "2.12.1" "sha256-uVd9KNIMx1p26vaOzlPNM7a0+2SS5ZkfpMe5obGDXiw=";

  types-aiobotocore-cognito-sync = buildTypesAiobotocorePackage "cognito-sync" "2.12.1" "sha256-NJVV8lN0HTmASQfqh9fbQSkg2KijOcbHTc8QYgTrY4I=";

  types-aiobotocore-comprehend = buildTypesAiobotocorePackage "comprehend" "2.12.1" "sha256-+WMvk9yY5bGHPqd93TWS3XC6XDvTzh54oM9py52pzws=";

  types-aiobotocore-comprehendmedical = buildTypesAiobotocorePackage "comprehendmedical" "2.12.1" "sha256-KFeZxBzsAZVdpIlvKohBIP3p1yJ14/AHW7sItn6slY4=";

  types-aiobotocore-compute-optimizer = buildTypesAiobotocorePackage "compute-optimizer" "2.12.1" "sha256-xCFDjZ+tkRs3UWhPu6BpabaKIFWITApu65gFk0hw/Vs=";

  types-aiobotocore-config = buildTypesAiobotocorePackage "config" "2.12.1" "sha256-cQWccDw2YPdj5pXb/H2WaFlWg4BrAg/HNAq6RLAp4yY=";

  types-aiobotocore-connect = buildTypesAiobotocorePackage "connect" "2.12.1" "sha256-zbAIII9gaTJEZEcdd1go00s6PUAZdNtEYlOu0Hz2K5g=";

  types-aiobotocore-connect-contact-lens = buildTypesAiobotocorePackage "connect-contact-lens" "2.12.1" "sha256-8QSM/rytw1tx8OfL3NQOaxT8D0hlFK4BmaxxPJGpeL0=";

  types-aiobotocore-connectcampaigns = buildTypesAiobotocorePackage "connectcampaigns" "2.12.1" "sha256-QJylFv6qLf+JS2FL2Fs9oXXkTbwgmcxChsXUjoJJIQ4=";

  types-aiobotocore-connectcases = buildTypesAiobotocorePackage "connectcases" "2.12.1" "sha256-5rHxLWeR6ElpegaV1lO6Wh8h0DBoZ8S4TblDPMlZvEg=";

  types-aiobotocore-connectparticipant = buildTypesAiobotocorePackage "connectparticipant" "2.12.1" "sha256-VSno3aW8mDf/yxg0bTERjsERvdd6+T4yOJQdA32o3bo=";

  types-aiobotocore-controltower = buildTypesAiobotocorePackage "controltower" "2.12.1" "sha256-3G2EarLZAonr/2noJ8sUlrvol6En37NfWqaKWkKUF40=";

  types-aiobotocore-cur = buildTypesAiobotocorePackage "cur" "2.12.1" "sha256-Q22cMbQCNx57+z5gVRWzEu+NFre7nr43iCfZckmzUqU=";

  types-aiobotocore-customer-profiles = buildTypesAiobotocorePackage "customer-profiles" "2.12.1" "sha256-qMPLsa4euoHZiaRizphbpw4H66mCxZhNKZM1qjILwy8=";

  types-aiobotocore-databrew = buildTypesAiobotocorePackage "databrew" "2.12.1" "sha256-ekG77cZnn6V9InRjhqUzJWGs4/ear90bifUP+RwCXz8=";

  types-aiobotocore-dataexchange = buildTypesAiobotocorePackage "dataexchange" "2.12.1" "sha256-L6bedg9iqlsB+0mt5GaZzB8RRepZGW1BahDXUwfNc+I=";

  types-aiobotocore-datapipeline = buildTypesAiobotocorePackage "datapipeline" "2.12.1" "sha256-EAkwiRw1PF3+6pdt15onwTBvXXf9f4BLQd6mqDLgYdk=";

  types-aiobotocore-datasync = buildTypesAiobotocorePackage "datasync" "2.12.1" "sha256-JZuIbuaaci7scqF27/7KZtkfpTa+FkE3Ooq84ZjL4Fg=";

  types-aiobotocore-dax = buildTypesAiobotocorePackage "dax" "2.12.1" "sha256-wtFXwUfDxUJSjt2FFvt6+eq1vSsHWwvBJvg1pyplX8Q=";

  types-aiobotocore-detective = buildTypesAiobotocorePackage "detective" "2.12.1" "sha256-ydMwZRT9F95KBrvlwGAqjiTiEUVnr0xKElMKz5dgRSM=";

  types-aiobotocore-devicefarm = buildTypesAiobotocorePackage "devicefarm" "2.12.1" "sha256-8GRf+xgsv8lTNuRlib78GMOV5gLMxiybo9gqgfL2s6g=";

  types-aiobotocore-devops-guru = buildTypesAiobotocorePackage "devops-guru" "2.12.1" "sha256-Jg4yLzlZGjlHqgKECEgGndcVGc28KCE0C8K4JhpjAXA=";

  types-aiobotocore-directconnect = buildTypesAiobotocorePackage "directconnect" "2.12.1" "sha256-wk0y4voHIlDmBMGTsOukcM4yG9XP4wnQA1WgAUb9T1c=";

  types-aiobotocore-discovery = buildTypesAiobotocorePackage "discovery" "2.12.1" "sha256-IctqTU+e65MHeo3Mm+MVzkyrzki8f0eSEWHvzTgTTlc=";

  types-aiobotocore-dlm = buildTypesAiobotocorePackage "dlm" "2.12.1" "sha256-dHKET+GhbmbRJzoziqtB2H1T36L9lFFU0HtNrPve4/o=";

  types-aiobotocore-dms = buildTypesAiobotocorePackage "dms" "2.12.1" "sha256-RIm9mkVCGtpMdib6ObpPxJgiME15tT9wm5UrQjLYicc=";

  types-aiobotocore-docdb = buildTypesAiobotocorePackage "docdb" "2.12.1" "sha256-F3BHJezYz2fHG/76JnOrc8J5jgAEJx82I+Lzhput4Bs=";

  types-aiobotocore-docdb-elastic = buildTypesAiobotocorePackage "docdb-elastic" "2.12.1" "sha256-GA13WEdMqY8SUctSK5o9N6B6F35RySbUQS7XxleRak0=";

  types-aiobotocore-drs = buildTypesAiobotocorePackage "drs" "2.12.1" "sha256-oMsLU3UfvqACSteoKKALYNV2qnXnxDkmE+TaVJV9cG0=";

  types-aiobotocore-ds = buildTypesAiobotocorePackage "ds" "2.12.1" "sha256-2FfD3ck4faAK5s85ELfI1jPH7icQZh3a8ALDIGxpBz4=";

  types-aiobotocore-dynamodb = buildTypesAiobotocorePackage "dynamodb" "2.12.1" "sha256-mi1byiYu/T2h65HtTgygYXS1tNxiDhnsIH+FGGpFq1A=";

  types-aiobotocore-dynamodbstreams = buildTypesAiobotocorePackage "dynamodbstreams" "2.12.1" "sha256-y7lR076HGKvwzK4AFExfys6yvddmHmH/h0Klb7ExIKw=";

  types-aiobotocore-ebs = buildTypesAiobotocorePackage "ebs" "2.12.1" "sha256-ji1opGGeCLCMvpYkbwKQ+bkEGkeV9ZhuxZ3uIcT4Vmk=";

  types-aiobotocore-ec2 = buildTypesAiobotocorePackage "ec2" "2.12.1" "sha256-Ep4MKh26Iv+2LE/BKQBF5gX539ujCIzb4uaeHdd3vK8=";

  types-aiobotocore-ec2-instance-connect = buildTypesAiobotocorePackage "ec2-instance-connect" "2.12.1" "sha256-UQJvL+kpS1A2ptVpWzDEBvLntIZiyLJu3IwASJQd+ik=";

  types-aiobotocore-ecr = buildTypesAiobotocorePackage "ecr" "2.12.1" "sha256-dOp+qRCpF+1hLgdlQTaLQcCEpST44ajxeJeepOwcU+U=";

  types-aiobotocore-ecr-public = buildTypesAiobotocorePackage "ecr-public" "2.12.1" "sha256-wwcl/GCHz17YisIylvjtkMXiRlqcHX8pf3K0sy2GtL8=";

  types-aiobotocore-ecs = buildTypesAiobotocorePackage "ecs" "2.12.1" "sha256-yVwVId7K3DLWTjgk3tLywZhgnAxFGEi2oAKfXfdO18w=";

  types-aiobotocore-efs = buildTypesAiobotocorePackage "efs" "2.12.1" "sha256-hk9CLjWumjbT4EUGQnXytjgc6qgeCQAJx51d2TK6u9U=";

  types-aiobotocore-eks = buildTypesAiobotocorePackage "eks" "2.12.1" "sha256-fGSU2Xx8VF/R3tFwqJlJGcgq4Mpv/NevgMsE0IVzRrY=";

  types-aiobotocore-elastic-inference = buildTypesAiobotocorePackage "elastic-inference" "2.12.1" "sha256-4SkFFVNIyY0vJjZ2uIwwyrN0LiOTj/6Oo1vWagRJtM4=";

  types-aiobotocore-elasticache = buildTypesAiobotocorePackage "elasticache" "2.12.1" "sha256-5X5icBKyZRNawv5lJzfDcyD2tFC9eLlJNHogV3ZM3tQ=";

  types-aiobotocore-elasticbeanstalk = buildTypesAiobotocorePackage "elasticbeanstalk" "2.12.1" "sha256-U9xp81RqyuAFNNYkYSjIpRBfsXKZanunVWAmAfR/ZVw=";

  types-aiobotocore-elastictranscoder = buildTypesAiobotocorePackage "elastictranscoder" "2.12.1" "sha256-Ggq93JeHa5+2hSwyHcFGRU7rMGHGPMAqaJPZj2KIUUU=";

  types-aiobotocore-elb = buildTypesAiobotocorePackage "elb" "2.12.1" "sha256-LzHkiRKqmdD/iXZhJu1G9eLltFJcIFwBhgiLgywyOcA=";

  types-aiobotocore-elbv2 = buildTypesAiobotocorePackage "elbv2" "2.12.1" "sha256-g1ozRS44owh8ogisOE7ydF7omi9LPdXLxO2JaEWDmlg=";

  types-aiobotocore-emr = buildTypesAiobotocorePackage "emr" "2.12.1" "sha256-14akL+yzo3/uV9Qsdpewt4Y88ghxVbV9aL6e8Qe+FFo=";

  types-aiobotocore-emr-containers = buildTypesAiobotocorePackage "emr-containers" "2.12.1" "sha256-zOLyra/2uaqKl1t5Z2FVyLqtMmlYRZFN9HaCd+ocXi0=";

  types-aiobotocore-emr-serverless = buildTypesAiobotocorePackage "emr-serverless" "2.12.1" "sha256-clBwlUdU9v90NEm744l6OB3QHuB+aUC3kQjLuHNKFdU=";

  types-aiobotocore-entityresolution = buildTypesAiobotocorePackage "entityresolution" "2.12.1" "sha256-3onJrgPQlgcNGPIUypd/ke5y3j4qt6vWF0fVgcwYsOg=";

  types-aiobotocore-es = buildTypesAiobotocorePackage "es" "2.12.1" "sha256-pgQ7UDfnBaITqhrRoxze9jTLaxyUR2MubCWc+VfQS6c=";

  types-aiobotocore-events = buildTypesAiobotocorePackage "events" "2.12.1" "sha256-zdeJ+xc6KaAc0wcBsRQq49GvkK735LgTBHOKALjXPPk=";

  types-aiobotocore-evidently = buildTypesAiobotocorePackage "evidently" "2.12.1" "sha256-BLolxhY1yHTi5jQajuJpBj7GtKAtxhVjkIN+X1yvGmY=";

  types-aiobotocore-finspace = buildTypesAiobotocorePackage "finspace" "2.12.1" "sha256-Rc7iPcraCISAebFQzU+Yxll+fYwi5b2hYO/3d1I3RRY=";

  types-aiobotocore-finspace-data = buildTypesAiobotocorePackage "finspace-data" "2.12.1" "sha256-B3RJZRLKtz+CBOnRo0YcqdHhUc3P1Owjk2EwNChrnK0=";

  types-aiobotocore-firehose = buildTypesAiobotocorePackage "firehose" "2.12.1" "sha256-D0+FLyDYDx4xroVaANmyQq5qLPGUdDfgPMtSKfVAiUg=";

  types-aiobotocore-fis = buildTypesAiobotocorePackage "fis" "2.12.1" "sha256-C99pmPa7zV9DZrc9stWxV9EPbJXwxslMyynj2PhbtDA=";

  types-aiobotocore-fms = buildTypesAiobotocorePackage "fms" "2.12.1" "sha256-/oj+/dwtRXH8WD5QWuxJTLfNfhqwJmdXJROHUzzzF68=";

  types-aiobotocore-forecast = buildTypesAiobotocorePackage "forecast" "2.12.1" "sha256-POwSXbfBT9xTA+b2dNFv7ONfYSv+N/Td9FW7EPDYbmA=";

  types-aiobotocore-forecastquery = buildTypesAiobotocorePackage "forecastquery" "2.12.1" "sha256-twtNBD27WYeuJNI5FuA6C98b5wjkRJSRqHmZ1fmArAc=";

  types-aiobotocore-frauddetector = buildTypesAiobotocorePackage "frauddetector" "2.12.1" "sha256-YDub5fFJg5efes6BtnwVEKnKhbbmDuyFHNTQ6O7SgOI=";

  types-aiobotocore-fsx = buildTypesAiobotocorePackage "fsx" "2.12.1" "sha256-lsDu0YT6015Or5STid9M8mbLXWxu7UkKgQHwTkgwnpY=";

  types-aiobotocore-gamelift = buildTypesAiobotocorePackage "gamelift" "2.12.1" "sha256-SX7bzOCoV3v6+CVb1eBfm6AxLRivUJ1zbZtxZ7D1jvg=";

  types-aiobotocore-gamesparks = buildTypesAiobotocorePackage "gamesparks" "2.7.0" "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier = buildTypesAiobotocorePackage "glacier" "2.12.1" "sha256-qKEzg0ruG6E8DPsi+xsJF5rbmcEraLrS0gQr3It8io0=";

  types-aiobotocore-globalaccelerator = buildTypesAiobotocorePackage "globalaccelerator" "2.12.1" "sha256-fjve8IEN0KcejFBwUxO1rstv8/CA0g0pS/0lxfnZx6k=";

  types-aiobotocore-glue = buildTypesAiobotocorePackage "glue" "2.12.1" "sha256-JYo3D3i2FtCKUatnLyDWW8YGB9u0SzQwDeC0tIBULms=";

  types-aiobotocore-grafana = buildTypesAiobotocorePackage "grafana" "2.12.1" "sha256-fByRGOJ1TnfnPB6czGYyjvKOop6chA7fiatsVPKCxys=";

  types-aiobotocore-greengrass = buildTypesAiobotocorePackage "greengrass" "2.12.1" "sha256-QhTA5b8q6LDdHVeN0M0mT/XLKTfDHIY71EXUCtSCqbI=";

  types-aiobotocore-greengrassv2 = buildTypesAiobotocorePackage "greengrassv2" "2.12.1" "sha256-b6DO2ZGOBzPZ311Fj+il6pkBmSXPKe12Ssua9T/mdjs=";

  types-aiobotocore-groundstation = buildTypesAiobotocorePackage "groundstation" "2.12.1" "sha256-XzlCvtOwGPUQEkU1HiGYeeAWuRAQpRnXDcgyblykJEE=";

  types-aiobotocore-guardduty = buildTypesAiobotocorePackage "guardduty" "2.12.1" "sha256-Y3FDX5NPe+s0CBawE0OsXaIBPhe4wfEoLOEhDLRl6Sc=";

  types-aiobotocore-health = buildTypesAiobotocorePackage "health" "2.12.1" "sha256-/Dn89WzfH67/4MFpkCHW5FGNdKDR5xAqZogAoo0uTb0=";

  types-aiobotocore-healthlake = buildTypesAiobotocorePackage "healthlake" "2.12.1" "sha256-K05QqhDzTN9S4xz9nYX/HMjtYQPRsUjo/lua+15kreA=";

  types-aiobotocore-honeycode = buildTypesAiobotocorePackage "honeycode" "2.12.1" "sha256-N/RNj96TYYIEF8tM4T1O9A386rWpey7vNeENARYuVR4=";

  types-aiobotocore-iam = buildTypesAiobotocorePackage "iam" "2.12.1" "sha256-m297NaucGsLk8wkezGmktS5L7dtvEHAclGDYo2LhOy0=";

  types-aiobotocore-identitystore = buildTypesAiobotocorePackage "identitystore" "2.12.1" "sha256-IpOR07RxE9OSF5Ia4haHw/N/SMIL6QWqNfmqhZrh5WI=";

  types-aiobotocore-imagebuilder = buildTypesAiobotocorePackage "imagebuilder" "2.12.1" "sha256-SHfM9cerQSj7NmBHkC++6U5O9jOM3O0wWUXnu58nmRU=";

  types-aiobotocore-importexport = buildTypesAiobotocorePackage "importexport" "2.12.1" "sha256-sflWs79vrb2/CW+Xnh/94qe97plOyzXqwn+wzYHRNrk=";

  types-aiobotocore-inspector = buildTypesAiobotocorePackage "inspector" "2.12.1" "sha256-EpF8oSl8c2CCf6c+R2Y+hvlfjGqxtLJfMFuABrUbb0c=";

  types-aiobotocore-inspector2 = buildTypesAiobotocorePackage "inspector2" "2.12.1" "sha256-/WC/HvLK+BYcWWRvoNaLPwVoFSnTEDedqOA1zqiNYh4=";

  types-aiobotocore-internetmonitor = buildTypesAiobotocorePackage "internetmonitor" "2.12.1" "sha256-nnvd49vG1ZofJbWAnr1ZUsSFT4Jgmnde4mTVb8bjX8w=";

  types-aiobotocore-iot = buildTypesAiobotocorePackage "iot" "2.12.1" "sha256-0/b7nYgrFnOComNlfvx0c+phkqsLTlQBQGubp1Md1AU=";

  types-aiobotocore-iot-data = buildTypesAiobotocorePackage "iot-data" "2.12.1" "sha256-FRCda6jDLcl1tI6PwTaYydY3jzrtJvmYlKvyCR766fM=";

  types-aiobotocore-iot-jobs-data = buildTypesAiobotocorePackage "iot-jobs-data" "2.12.1" "sha256-OkKiROSuCZ1Dy2/Jeoby0J3obSRRXToTUUUfY2bwlVk=";

  types-aiobotocore-iot-roborunner = buildTypesAiobotocorePackage "iot-roborunner" "2.12.1" "sha256-Mstavqb84CltIUmh5aw+Q5+6+w90ErjP9MYlsFrQSZQ=";

  types-aiobotocore-iot1click-devices = buildTypesAiobotocorePackage "iot1click-devices" "2.12.1" "sha256-+JiJr+Vvn1MZEKtRAtNNTlv9JEiX4hCzF0mcrCZBnvY=";

  types-aiobotocore-iot1click-projects = buildTypesAiobotocorePackage "iot1click-projects" "2.12.1" "sha256-044QFOHWRDFqiOA/JQ904BO46+P+/GWyqJrW+FyFs+w=";

  types-aiobotocore-iotanalytics = buildTypesAiobotocorePackage "iotanalytics" "2.12.1" "sha256-2ZCngNUtPYX1m173bPtZ9Xn4t8bVSZ4IQG2Rlux/aAs=";

  types-aiobotocore-iotdeviceadvisor = buildTypesAiobotocorePackage "iotdeviceadvisor" "2.12.1" "sha256-9Zby+hIaVQuoqHcSRulQ8+F4RIgTHzfNPSUcEm6x430=";

  types-aiobotocore-iotevents = buildTypesAiobotocorePackage "iotevents" "2.12.1" "sha256-eIGobenbMUDi7cuh28zbb2BP6IIsAxmOU6sj5dSJwbU=";

  types-aiobotocore-iotevents-data = buildTypesAiobotocorePackage "iotevents-data" "2.12.1" "sha256-yWAqc6peQ/fpKo9aokUzSHAq4PCuwKGzYUUsnxVEuCU=";

  types-aiobotocore-iotfleethub = buildTypesAiobotocorePackage "iotfleethub" "2.12.1" "sha256-/G5zzVrwFwalyD/k0liRV0jI+zREXYEu35d8sQutKIc=";

  types-aiobotocore-iotfleetwise = buildTypesAiobotocorePackage "iotfleetwise" "2.12.1" "sha256-c9z+iY9RNWFO3U+88O+FQPGLMbFTtOUrXu7E5Iq5n8g=";

  types-aiobotocore-iotsecuretunneling = buildTypesAiobotocorePackage "iotsecuretunneling" "2.12.1" "sha256-2PstSZB2bk+Sz9q9DsNX0GoVGFwiYx/YOjlH1wZchXk=";

  types-aiobotocore-iotsitewise = buildTypesAiobotocorePackage "iotsitewise" "2.12.1" "sha256-lgn9uGyoyF5CAgOOpHRGdjMjb78u9EQ0Nf9QTzyyW5U=";

  types-aiobotocore-iotthingsgraph = buildTypesAiobotocorePackage "iotthingsgraph" "2.12.1" "sha256-Fy+88mBmjUgnRUqM2VLvvI5SWuY04o1aq4WHNk69B7w=";

  types-aiobotocore-iottwinmaker = buildTypesAiobotocorePackage "iottwinmaker" "2.12.1" "sha256-yhSsgqu/fPILYTEOuL+1g5bKC3V7nyegYg8WPO8/vQI=";

  types-aiobotocore-iotwireless = buildTypesAiobotocorePackage "iotwireless" "2.12.1" "sha256-y4nUuqr++tjN7/JT0cYM5aY01iOGNXU57fjZUTJuP5E=";

  types-aiobotocore-ivs = buildTypesAiobotocorePackage "ivs" "2.12.1" "sha256-vXYET71jHEMKdA6mFFVjjv1uK4tREDu5vXfXh5dOwZA=";

  types-aiobotocore-ivs-realtime = buildTypesAiobotocorePackage "ivs-realtime" "2.12.1" "sha256-mr+I1UbBSvw6y33vuSwaqCyT33zA1LhJmsvnkYL6970=";

  types-aiobotocore-ivschat = buildTypesAiobotocorePackage "ivschat" "2.12.1" "sha256-OXY0CRbaYPyOw68acgRJ0bHiy96dc70f30PbC8X7gSY=";

  types-aiobotocore-kafka = buildTypesAiobotocorePackage "kafka" "2.12.1" "sha256-knkfB2mafoeDKpNdnAZoOgcym/Qd3JraROwqneN9GPg=";

  types-aiobotocore-kafkaconnect = buildTypesAiobotocorePackage "kafkaconnect" "2.12.1" "sha256-40wG7JtuSibwSMl0XCeOxvJlYKBNc6SmyrxHYRLYtxc=";

  types-aiobotocore-kendra = buildTypesAiobotocorePackage "kendra" "2.12.1" "sha256-MqwoPPEnEv7uLRE+U5vFge2vr3/g5iYnyztbKJ9/ATc=";

  types-aiobotocore-kendra-ranking = buildTypesAiobotocorePackage "kendra-ranking" "2.12.1" "sha256-P25wxbzWNmFdcCR6eX+M27jMqQzCdM4L1AerLzltIUg=";

  types-aiobotocore-keyspaces = buildTypesAiobotocorePackage "keyspaces" "2.12.1" "sha256-eMucpOTz1CpzfAuJIyAkR1Kr0qF1F5B03qpcNHR6c/Y=";

  types-aiobotocore-kinesis = buildTypesAiobotocorePackage "kinesis" "2.12.1" "sha256-J7U0j1XJB2ikTT1IfLcxltTczzqWDkmTP/8I/QIdvlE=";

  types-aiobotocore-kinesis-video-archived-media = buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.12.1" "sha256-y7ALdUdp9fTc2b2hVtufJATcm8c8YjbR/fEnX5ynbX4=";

  types-aiobotocore-kinesis-video-media = buildTypesAiobotocorePackage "kinesis-video-media" "2.12.1" "sha256-jKMh2sbz1kIuKmx6qZYj+ZhMTaAORLux+X6oVrno8Fk=";

  types-aiobotocore-kinesis-video-signaling = buildTypesAiobotocorePackage "kinesis-video-signaling" "2.12.1" "sha256-DrZHSwqfQZ+mn5wmuWR3MbjolGkOg7mmnKr5uI/NGWo=";

  types-aiobotocore-kinesis-video-webrtc-storage = buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.12.1" "sha256-38R/9LUDMvNhAXmEA2sMR4KE+jB6O0hHJLaowPEnlMQ=";

  types-aiobotocore-kinesisanalytics = buildTypesAiobotocorePackage "kinesisanalytics" "2.12.1" "sha256-LnyZhLCGcN0Qbam0x+ALYGZlYky/ldLUg03bxRlyhf8=";

  types-aiobotocore-kinesisanalyticsv2 = buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.12.1" "sha256-giSsTelOj3/bF5uPHx6WJhdKtqL6QljcU3l+Tp7aR4k=";

  types-aiobotocore-kinesisvideo = buildTypesAiobotocorePackage "kinesisvideo" "2.12.1" "sha256-lmaTXcxKgevwoWJeUxTHmynCcZaIHXmnJjjvFAARLJw=";

  types-aiobotocore-kms = buildTypesAiobotocorePackage "kms" "2.12.1" "sha256-vonZnhR5Rh2ZVlXlBTuSfE6ipVliGKMIdhBAV6pl1NU=";

  types-aiobotocore-lakeformation = buildTypesAiobotocorePackage "lakeformation" "2.12.1" "sha256-IFFB7sUhrW46nrmQR/bSRTjVye+3C3eGQCrpe3jNVxs=";

  types-aiobotocore-lambda = buildTypesAiobotocorePackage "lambda" "2.12.1" "sha256-A1oS/awripZCCFwwP3bpPt8xAn8MKHBd4Y7nDG9Beo0=";

  types-aiobotocore-lex-models = buildTypesAiobotocorePackage "lex-models" "2.12.1" "sha256-W8xa7bl2wYS3SY6rZk7T65UvwntxCY9OHKKtVaDUMq8=";

  types-aiobotocore-lex-runtime = buildTypesAiobotocorePackage "lex-runtime" "2.12.1" "sha256-IODLqqjC6UXTkT980S+drXqhnkNWH2ejzVWeo1LE45U=";

  types-aiobotocore-lexv2-models = buildTypesAiobotocorePackage "lexv2-models" "2.12.1" "sha256-Jf2MQbBanDZetFUVH/5CVMYDzzBN7Th8K6RVUWkYaQc=";

  types-aiobotocore-lexv2-runtime = buildTypesAiobotocorePackage "lexv2-runtime" "2.12.1" "sha256-jAsyQqIj3YXfEa6q/cZIPIjal+3YJqts6N13I5O+kHw=";

  types-aiobotocore-license-manager = buildTypesAiobotocorePackage "license-manager" "2.12.1" "sha256-AWe9VEJxap7+tL0flZqs2/SQemIzGKXJXWxx1ScLtC8=";

  types-aiobotocore-license-manager-linux-subscriptions = buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.12.1" "sha256-0HhhZH3OBYQBK1q9RyqJqCBmINMzgZfj20iFVmPYMac=";

  types-aiobotocore-license-manager-user-subscriptions = buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.12.1" "sha256-K7KXzCtdGS6ok79zNDxx9PxXPNbNPsp6fuucT/Us2/M=";

  types-aiobotocore-lightsail = buildTypesAiobotocorePackage "lightsail" "2.12.1" "sha256-lRlifiUJCGbVkf0wVdrXQiwoOvQPqrXrvzl/4BqXpsM=";

  types-aiobotocore-location = buildTypesAiobotocorePackage "location" "2.12.1" "sha256-j+UcTL5YYpI5eCmWq1durTCIwuc0U94udfgNUCAgR9A=";

  types-aiobotocore-logs = buildTypesAiobotocorePackage "logs" "2.12.1" "sha256-CqByIbfkIeROXAFWvjS9pwPImo2dD10q1/7kTR5GA9w=";

  types-aiobotocore-lookoutequipment = buildTypesAiobotocorePackage "lookoutequipment" "2.12.1" "sha256-++dMJ+uFbNkbRVKbMP3URxlKRj9pm6Je6+iQTAs3vqU=";

  types-aiobotocore-lookoutmetrics = buildTypesAiobotocorePackage "lookoutmetrics" "2.12.1" "sha256-rInxd7NLuze5qs4fV47PmnptYPKyj/IwrHhrND/ufgw=";

  types-aiobotocore-lookoutvision = buildTypesAiobotocorePackage "lookoutvision" "2.12.1" "sha256-HOVBuDQoYpTCfie8GyyyrTY09OwXW8JvzO6eJJxQncI=";

  types-aiobotocore-m2 = buildTypesAiobotocorePackage "m2" "2.12.1" "sha256-e8jfy4ilPA0NLZMeP6zkrPhkGqLXKBX2bDSfu+bLpPY=";

  types-aiobotocore-machinelearning = buildTypesAiobotocorePackage "machinelearning" "2.12.1" "sha256-A++bU7yYnFfL7FmAHqh6906dJb3YusAWBr9lHk7l608=";

  types-aiobotocore-macie = buildTypesAiobotocorePackage "macie" "2.7.0" "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 = buildTypesAiobotocorePackage "macie2" "2.12.1" "sha256-Cm8DEoGP6TwqvJcU4+JiYwkYKQP3GGKyAVY95lSUHmY=";

  types-aiobotocore-managedblockchain = buildTypesAiobotocorePackage "managedblockchain" "2.12.1" "sha256-PWM8WIxLZTjGch2Mhu9n0v0x63fGK0J6XcL8U0MXEMs=";

  types-aiobotocore-managedblockchain-query = buildTypesAiobotocorePackage "managedblockchain-query" "2.12.1" "sha256-7sCnI6B/QM7AcB2iEDCSNKRgIcFCUyJct2Jg/KoQk64=";

  types-aiobotocore-marketplace-catalog = buildTypesAiobotocorePackage "marketplace-catalog" "2.12.1" "sha256-ho34PTQaL4POvic2Nzy+fuCYanrXGOXN9Jf+qd+dMX4=";

  types-aiobotocore-marketplace-entitlement = buildTypesAiobotocorePackage "marketplace-entitlement" "2.12.1" "sha256-pdRHgmA3ul+2ww+hOO2TTs7brvMAXZXM7QQTqTWfDz4=";

  types-aiobotocore-marketplacecommerceanalytics = buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.12.1" "sha256-rXnL667PBKx5IxK3YJzJiWN8wFlDvz09RjaIMrVIyZo=";

  types-aiobotocore-mediaconnect = buildTypesAiobotocorePackage "mediaconnect" "2.12.1" "sha256-bm/2aSToVTIaxBs0i/v4As2mX4vK81RqZIjzgrQYP+g=";

  types-aiobotocore-mediaconvert = buildTypesAiobotocorePackage "mediaconvert" "2.12.1" "sha256-52088rNi5Vuf0CuDU2LdXV4ZSoWaHqBeTD42DOEmDTs=";

  types-aiobotocore-medialive = buildTypesAiobotocorePackage "medialive" "2.12.1" "sha256-/B3qy79nPiz8Xo5KxJKDnUKo6PclE/pXrkjSJmlcz9I=";

  types-aiobotocore-mediapackage = buildTypesAiobotocorePackage "mediapackage" "2.12.1" "sha256-a3qTy0sS8J8iEBvcPCXAC2lSLuuhEbslLork1HaHrF8=";

  types-aiobotocore-mediapackage-vod = buildTypesAiobotocorePackage "mediapackage-vod" "2.12.1" "sha256-4jyIrHer52rwi0ry9uBhMPm2YbzEWqhiHaSPqHfFr98=";

  types-aiobotocore-mediapackagev2 = buildTypesAiobotocorePackage "mediapackagev2" "2.12.1" "sha256-KOFEpAVUnaN607soHl7SCq79KU/qS/ab/GGH9QEQJ4Y=";

  types-aiobotocore-mediastore = buildTypesAiobotocorePackage "mediastore" "2.12.1" "sha256-A4V8LMaloeRlOBNIEI43I4Rkyl2NllwB87XJVy9KDGo=";

  types-aiobotocore-mediastore-data = buildTypesAiobotocorePackage "mediastore-data" "2.12.1" "sha256-tXvQxnQSShN4gVQunAhmKEQztuJfJpxxvhXTh3kXyKA=";

  types-aiobotocore-mediatailor = buildTypesAiobotocorePackage "mediatailor" "2.12.1" "sha256-7FvUjBLyNRBZOApbvurtXt0exH9htacmJq9exlGBDMg=";

  types-aiobotocore-medical-imaging = buildTypesAiobotocorePackage "medical-imaging" "2.12.1" "sha256-NVA0xf98DhJXfzNdLu42lV+ilO8gz2ZRt/Kxk68GP9I=";

  types-aiobotocore-memorydb = buildTypesAiobotocorePackage "memorydb" "2.12.1" "sha256-hn/83GWPAn6UL8Ez+L/mdiGPy0ycFvNDcLcEvAd/+a8=";

  types-aiobotocore-meteringmarketplace = buildTypesAiobotocorePackage "meteringmarketplace" "2.12.1" "sha256-SNGrScKSyEp35Aq+vs+uXk67ab0M1tjwkOuO/mmgrtY=";

  types-aiobotocore-mgh = buildTypesAiobotocorePackage "mgh" "2.12.1" "sha256-lbmcxyFquZmbFEmQbmIY6lqdJmukR1dLkH9CgS52MQM=";

  types-aiobotocore-mgn = buildTypesAiobotocorePackage "mgn" "2.12.1" "sha256-NNjPCZxxV3Nx0+2OTV93SLN3AM6wF2Uqq8BNaWm2dVk=";

  types-aiobotocore-migration-hub-refactor-spaces = buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.12.1" "sha256-eHH4V6svWNwjD9StyvyxTZ4DTwVsBX0VU65mTcKMZ7k=";

  types-aiobotocore-migrationhub-config = buildTypesAiobotocorePackage "migrationhub-config" "2.12.1" "sha256-rMCfG8GrTGzFBPE6oS+2DSZ7rD2XW1weGImOO85nDP4=";

  types-aiobotocore-migrationhuborchestrator = buildTypesAiobotocorePackage "migrationhuborchestrator" "2.12.1" "sha256-uGWiICcRZzVCCKPmWwqV0JoytgeVFcJexgLcUE64PCM=";

  types-aiobotocore-migrationhubstrategy = buildTypesAiobotocorePackage "migrationhubstrategy" "2.12.1" "sha256-wcN2fJO1BrHJiItDkqIxvvWwnzFIw9YQCQYKfbfi4Xc=";

  types-aiobotocore-mobile = buildTypesAiobotocorePackage "mobile" "2.12.1" "sha256-p5uySMWHaMLvdFP4qlWySsUByqw/8YrYAkJSWdLC4B4=";

  types-aiobotocore-mq = buildTypesAiobotocorePackage "mq" "2.12.1" "sha256-RI5nNpGCl4jXeAla990a6R5+YH+IyR9dpkxbSrI30dM=";

  types-aiobotocore-mturk = buildTypesAiobotocorePackage "mturk" "2.12.1" "sha256-VHQSTVDau/EDXslby+ZFsBqDd5iPM7jlZ4SNsr1fh2Y=";

  types-aiobotocore-mwaa = buildTypesAiobotocorePackage "mwaa" "2.12.1" "sha256-CX58a5H9pYhMlXqf9hx2HRmqYUInLBmfEhX6/VqYG64=";

  types-aiobotocore-neptune = buildTypesAiobotocorePackage "neptune" "2.12.1" "sha256-RdCi4jseTuX11ZqNdvnH6Lral68aVKE9xehhhinCE6M=";

  types-aiobotocore-network-firewall = buildTypesAiobotocorePackage "network-firewall" "2.12.1" "sha256-1xujtFAG0Jh65Ds6MrgY0Tw4KyYMRFbll30t0S+Pc2g=";

  types-aiobotocore-networkmanager = buildTypesAiobotocorePackage "networkmanager" "2.12.1" "sha256-1nBKGtnU7PaZXhsrwBZbJfwGdbi5FPFwszIXxmw/HGg=";

  types-aiobotocore-nimble = buildTypesAiobotocorePackage "nimble" "2.12.1" "sha256-zLrnjFSKA53wgxsStGQfLqogX5u2l58kdzOFTTgelQA=";

  types-aiobotocore-oam = buildTypesAiobotocorePackage "oam" "2.12.1" "sha256-Ujm2i+dRU3STj+A58KZS/Ypkod36JpWlXvAKO/NLErs=";

  types-aiobotocore-omics = buildTypesAiobotocorePackage "omics" "2.12.1" "sha256-uMef3Qrh+H631nsOsy7OEB4zeETR707ld6Jz6NjWwL8=";

  types-aiobotocore-opensearch = buildTypesAiobotocorePackage "opensearch" "2.12.1" "sha256-kSnMbexNutPYHJfj4qgbFR3mhOU3rWputXUhBu7rFeo=";

  types-aiobotocore-opensearchserverless = buildTypesAiobotocorePackage "opensearchserverless" "2.12.1" "sha256-N5vfHByujicDNnRiXIWkudjivmPoNeEpsnZYeX18Uok=";

  types-aiobotocore-opsworks = buildTypesAiobotocorePackage "opsworks" "2.12.1" "sha256-7R8AtGb0Gt6XfWBUYSjudRUGRGF2tp9Ey3Bqh6LJ7wM=";

  types-aiobotocore-opsworkscm = buildTypesAiobotocorePackage "opsworkscm" "2.12.1" "sha256-5N/yQdfPTdJTkF2Yo0szvLK7tHYBALqahIbTwG2YSFM=";

  types-aiobotocore-organizations = buildTypesAiobotocorePackage "organizations" "2.12.1" "sha256-CEEKhdfh//GBT9pbOqu3pxCg0iy83LBy172FmVWbnK8=";

  types-aiobotocore-osis = buildTypesAiobotocorePackage "osis" "2.12.1" "sha256-IRo94LgBBk4sawgE9fpySggeG6EjmyLRf7cHLzIYcBo=";

  types-aiobotocore-outposts = buildTypesAiobotocorePackage "outposts" "2.12.1" "sha256-PXACndLusmvG0cYQESek4mr/k376seaNia4x0KqufBk=";

  types-aiobotocore-panorama = buildTypesAiobotocorePackage "panorama" "2.12.1" "sha256-58uOgEi1MyxZU4rRG8WO2IEUq7YWG2nIgQwcPQG770o=";

  types-aiobotocore-payment-cryptography = buildTypesAiobotocorePackage "payment-cryptography" "2.12.1" "sha256-dOUHOX72DzvICM0jPPZueDkvasPRp01JwubfeaUSqWk=";

  types-aiobotocore-payment-cryptography-data = buildTypesAiobotocorePackage "payment-cryptography-data" "2.12.1" "sha256-qK5LnCwuiMJB1s5T1ncVOF45q5VILHO5SHhpCD5G0kk=";

  types-aiobotocore-personalize = buildTypesAiobotocorePackage "personalize" "2.12.1" "sha256-p94/gqPE0V5HRmC+bSqx5yGg6hyVYJE1w9lGwruONX8=";

  types-aiobotocore-personalize-events = buildTypesAiobotocorePackage "personalize-events" "2.12.1" "sha256-GsyLDjpZvGnf8dAWB+ibT0ZuRts2WU8P3fQ2i2Wwjn4=";

  types-aiobotocore-personalize-runtime = buildTypesAiobotocorePackage "personalize-runtime" "2.12.1" "sha256-Oq7DFo4Xi7a7naEflLlPDaR2zpFv1/cKjMsQfAMshT8=";

  types-aiobotocore-pi = buildTypesAiobotocorePackage "pi" "2.12.1" "sha256-RyvXuiebtNWG49SBbKmwFYRKxd6Ba/UKNphCxZ3XhVQ=";

  types-aiobotocore-pinpoint = buildTypesAiobotocorePackage "pinpoint" "2.12.1" "sha256-UWnbgABQfwd2rUz952iFMh1QPdEchzgw/aeggi/+/9A=";

  types-aiobotocore-pinpoint-email = buildTypesAiobotocorePackage "pinpoint-email" "2.12.1" "sha256-WinsN8jm/Ua0iYhMS5FAHlELJYbpfH8TRzRJEcQGevc=";

  types-aiobotocore-pinpoint-sms-voice = buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.12.1" "sha256-OcP5l7Xc8AIY9c9/Cx3a6JzNFu3kC0+pH5/TzNjgbqQ=";

  types-aiobotocore-pinpoint-sms-voice-v2 = buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.12.1" "sha256-9uVmiRlhT66EYFgoImQa7uLhX8HvvO4mo6wW1dwUkmk=";

  types-aiobotocore-pipes = buildTypesAiobotocorePackage "pipes" "2.12.1" "sha256-T5ggvFxgi2rWsOw+vArGx9zVLmGZxB4fsZ+GIz6X13U=";

  types-aiobotocore-polly = buildTypesAiobotocorePackage "polly" "2.12.1" "sha256-6thPshwvWCl4666WKAUyFL8JcNbvZ6mRHpvRSeZrvxE=";

  types-aiobotocore-pricing = buildTypesAiobotocorePackage "pricing" "2.12.1" "sha256-2vFSQr2uFCWEOjBtmQjAWyKw85/NfKuDGKnu6Vfq85s=";

  types-aiobotocore-privatenetworks = buildTypesAiobotocorePackage "privatenetworks" "2.12.1" "sha256-NCiA+mnWkeS6li7ruHZ8k2UM2rpHWJbE0UohIDhGDko=";

  types-aiobotocore-proton = buildTypesAiobotocorePackage "proton" "2.12.1" "sha256-2exlCIbq2xS+kvRR+LBEe0//Oit9wXhPxrITzASk6SI=";

  types-aiobotocore-qldb = buildTypesAiobotocorePackage "qldb" "2.12.1" "sha256-C7JHRm/SnRWMCBMzcpmmByMtcsK9Ozwd/IauoKKoZag=";

  types-aiobotocore-qldb-session = buildTypesAiobotocorePackage "qldb-session" "2.12.1" "sha256-3xfvNRLpJD+eUH4yLzNSYYf2g9OLmgEAOP7VKu/eaho=";

  types-aiobotocore-quicksight = buildTypesAiobotocorePackage "quicksight" "2.12.1" "sha256-BgO49MbWTu63gi8NoILgqOH7fnZmsSwCoxMNUBOzrvg=";

  types-aiobotocore-ram = buildTypesAiobotocorePackage "ram" "2.12.1" "sha256-EXG6jgh2RWvjURXu0I4qQprATS3Ip35gEQK6MLhE6SU=";

  types-aiobotocore-rbin = buildTypesAiobotocorePackage "rbin" "2.12.1" "sha256-WgPe6GjNL9F/VdQs4pp3xK0f5dyR23JZyfehm5I6sTo=";

  types-aiobotocore-rds = buildTypesAiobotocorePackage "rds" "2.12.1" "sha256-lgeDWUKBZCxVJayyytTiYbQboTdRBvIu7/HvhO4Wqkc=";

  types-aiobotocore-rds-data = buildTypesAiobotocorePackage "rds-data" "2.12.1" "sha256-/m11lpU8mBO1DkvbN9hg090aCjTLrqaULpCBUnCadSk=";

  types-aiobotocore-redshift = buildTypesAiobotocorePackage "redshift" "2.12.1" "sha256-/VL1Bzn27YKCL+Awdfg+4g+cg1ZD8Z9xvVS+jN91PU0=";

  types-aiobotocore-redshift-data = buildTypesAiobotocorePackage "redshift-data" "2.12.1" "sha256-OUTaZTCSUJLzzBNoxxHDCn+LRodqeakEgteHIjfyM7s=";

  types-aiobotocore-redshift-serverless = buildTypesAiobotocorePackage "redshift-serverless" "2.12.1" "sha256-nkRZzNd0KdBdb4pEbpr8oHAiAOzuMo8RNXJiKtTXT00=";

  types-aiobotocore-rekognition = buildTypesAiobotocorePackage "rekognition" "2.12.1" "sha256-05PKIuZPVLdYoVeeDVYrhR6Y6YJq41Sm0zql3GMd2GE=";

  types-aiobotocore-resiliencehub = buildTypesAiobotocorePackage "resiliencehub" "2.12.1" "sha256-BI7AQcnbbmA3jAE+weckSULbCLi7L+E6Bviwcp6nUTY=";

  types-aiobotocore-resource-explorer-2 = buildTypesAiobotocorePackage "resource-explorer-2" "2.12.1" "sha256-5QLkLGSEVy4WunpnwixrY7NC74G0qscsyRRonAiziuM=";

  types-aiobotocore-resource-groups = buildTypesAiobotocorePackage "resource-groups" "2.12.1" "sha256-ulM+lDPXOSw//ATwgvHUwRN6mt4JCPxsI9kvlFeBW8g=";

  types-aiobotocore-resourcegroupstaggingapi = buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.12.1" "sha256-eNAIL3H4R2DeCcPD80gmgCPw6OajhHMfyAAYsLZ5qk0=";

  types-aiobotocore-robomaker = buildTypesAiobotocorePackage "robomaker" "2.12.1" "sha256-mEDDY5dN90CuxIe48KECB4FnVikxO+5sGzb0HznEWgQ=";

  types-aiobotocore-rolesanywhere = buildTypesAiobotocorePackage "rolesanywhere" "2.12.1" "sha256-ZrGHBUThGVUUmy/TJDyG3hjNXGkRqO5oQP8SkIyCCu0=";

  types-aiobotocore-route53 = buildTypesAiobotocorePackage "route53" "2.12.1" "sha256-6qYcsh/D1+JhAAKCCpfsi8hOQndu6iLKQIAX0/j2UUE=";

  types-aiobotocore-route53-recovery-cluster = buildTypesAiobotocorePackage "route53-recovery-cluster" "2.12.1" "sha256-0PlKImcsyHMot9P8yjVLo6gt/pMr+xdMJTGoW5lcdqQ=";

  types-aiobotocore-route53-recovery-control-config = buildTypesAiobotocorePackage "route53-recovery-control-config" "2.12.1" "sha256-f+9lv8WRb723cgw2339xAXv6H9DSqTV3He2rOSfdLZs=";

  types-aiobotocore-route53-recovery-readiness = buildTypesAiobotocorePackage "route53-recovery-readiness" "2.12.1" "sha256-fYyZULP5ZPGa29XG81sfeLzJyM2a01fSzpasDmKQKaY=";

  types-aiobotocore-route53domains = buildTypesAiobotocorePackage "route53domains" "2.12.1" "sha256-jyZnn8+Z/ca81BFLz9STnRT5rVdgRbovqesUWFmzxSY=";

  types-aiobotocore-route53resolver = buildTypesAiobotocorePackage "route53resolver" "2.12.1" "sha256-chqu+C8HGB0P8KsfttB1oKnyaZY3GUcFgeikJcWeFo8=";

  types-aiobotocore-rum = buildTypesAiobotocorePackage "rum" "2.12.1" "sha256-x2b5L14Zx3XFSLOC9UPbRpOAiFd7jzd9UrLA9b+5+Ww=";

  types-aiobotocore-s3 = buildTypesAiobotocorePackage "s3" "2.12.1" "sha256-sHbgvSbUD55nQ46ufvPpngzCt0O4zIIDd8FlXH8TGF8=";

  types-aiobotocore-s3control = buildTypesAiobotocorePackage "s3control" "2.12.1" "sha256-p4AG4soN/NYbh1EPRc9DGtNtG89QRlarqVCPrKQcRqE=";

  types-aiobotocore-s3outposts = buildTypesAiobotocorePackage "s3outposts" "2.12.1" "sha256-EGR13xcf88tYBn5lbmrAQ2cxO6xDiFvuGA+xGp/o24Y=";

  types-aiobotocore-sagemaker = buildTypesAiobotocorePackage "sagemaker" "2.12.1" "sha256-YmBdTNil9ghlUrcr6Ej8GfwFaICQ+QZokuJk5iaHtY4=";

  types-aiobotocore-sagemaker-a2i-runtime = buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.12.1" "sha256-+fLY+MOh3P3/N7tVDGYZDlB7IKKMjxCdqje6apUGkQs=";

  types-aiobotocore-sagemaker-edge = buildTypesAiobotocorePackage "sagemaker-edge" "2.12.1" "sha256-izwrksagyX2mbDR1w+9ErrqrzHC1nnlIqXgE9++fGJI=";

  types-aiobotocore-sagemaker-featurestore-runtime = buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.12.1" "sha256-Kt8weJY6HFekwsF+de0VUqwkpGj+j+4GH5/Ct6ggBXc=";

  types-aiobotocore-sagemaker-geospatial = buildTypesAiobotocorePackage "sagemaker-geospatial" "2.12.1" "sha256-mdXNrA1f96TxH5MRUsr1aadj20R0tqQ0kwmawaskZX8=";

  types-aiobotocore-sagemaker-metrics = buildTypesAiobotocorePackage "sagemaker-metrics" "2.12.1" "sha256-VlaupOFkaHjjp1+Hjbmo8QHl/2tItZYg8t4WORUXGzg=";

  types-aiobotocore-sagemaker-runtime = buildTypesAiobotocorePackage "sagemaker-runtime" "2.12.1" "sha256-kGep+vJ4bqzTURgVEc3QESgmvBZJizk7SDWf2ELHPKM=";

  types-aiobotocore-savingsplans = buildTypesAiobotocorePackage "savingsplans" "2.12.1" "sha256-sN2ihAQiOi6Rp2Nl1HyETUZxz/B09IH4yLUGEOG2khw=";

  types-aiobotocore-scheduler = buildTypesAiobotocorePackage "scheduler" "2.12.1" "sha256-7Yn5P3j5URK4oiEgyokKEazP9zRan5laX4pyXoLlCGM=";

  types-aiobotocore-schemas = buildTypesAiobotocorePackage "schemas" "2.12.1" "sha256-sN7ixP27dN1ojaw/W3I2/VJFx5snuWEpJ1LugHx5tQs=";

  types-aiobotocore-sdb = buildTypesAiobotocorePackage "sdb" "2.12.1" "sha256-YwurPoYxG2ldprgCtLrn8jsHDAuqzxgOk+rBIrYdI8o=";

  types-aiobotocore-secretsmanager = buildTypesAiobotocorePackage "secretsmanager" "2.12.1" "sha256-DhKCgIIcxNIP2gJRZVA6ITP5k/wbI73JEpGFVNbriEo=";

  types-aiobotocore-securityhub = buildTypesAiobotocorePackage "securityhub" "2.12.1" "sha256-WDKxtbB1RZEG5eJbIKBddS8yX2YkbfzW6IabYivCpy4=";

  types-aiobotocore-securitylake = buildTypesAiobotocorePackage "securitylake" "2.12.1" "sha256-TG+xWDnQmXp55RcTP3GYIKdGUh9sLcU+AbpS+YnI0T4=";

  types-aiobotocore-serverlessrepo = buildTypesAiobotocorePackage "serverlessrepo" "2.12.1" "sha256-NEdGr3+zYFsxgL9xPyZqllQm9q5U3Y8Fq4vnjE9VQDk=";

  types-aiobotocore-service-quotas = buildTypesAiobotocorePackage "service-quotas" "2.12.1" "sha256-ZYzfFp+HQZCzBKG2Uaar44IO6rk3rPX8D00vAh5drsQ=";

  types-aiobotocore-servicecatalog = buildTypesAiobotocorePackage "servicecatalog" "2.12.1" "sha256-B1nyXU/z+ZR7MaPqqAIER3g+XQJDx37PTfvTHxSzHkQ=";

  types-aiobotocore-servicecatalog-appregistry = buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.12.1" "sha256-kQaEpE5fbWumtroUFNuyKrmXI7MmoNmJhWEh4ve1sYA=";

  types-aiobotocore-servicediscovery = buildTypesAiobotocorePackage "servicediscovery" "2.12.1" "sha256-V6TD1sOtO5AkbBrKVXr5dc2Ym7Mgz/dkm7c4rBNZOzw=";

  types-aiobotocore-ses = buildTypesAiobotocorePackage "ses" "2.12.1" "sha256-agdBiB1VRs38GxuHsBkHByWbBqrAt+YZNTfBFDIhgLE=";

  types-aiobotocore-sesv2 = buildTypesAiobotocorePackage "sesv2" "2.12.1" "sha256-ziNzhAspWnYDGxJfw5JPBf6FY0of0q2KddVZA4n1Trg=";

  types-aiobotocore-shield = buildTypesAiobotocorePackage "shield" "2.12.1" "sha256-Z289uZBMaexBmuG2aEfUWOy145jJC8ZHnaKb7lhjL7o=";

  types-aiobotocore-signer = buildTypesAiobotocorePackage "signer" "2.12.1" "sha256-MDoK/Qnvo6Y+WsVFSyKt+irzFC/HgWNAHkZgj3LSp4w=";

  types-aiobotocore-simspaceweaver = buildTypesAiobotocorePackage "simspaceweaver" "2.12.1" "sha256-tpzwKKdv8G0E0H3+wrANs50K0mM/lyqcXeTprBQeVNs=";

  types-aiobotocore-sms = buildTypesAiobotocorePackage "sms" "2.12.1" "sha256-mr5ntl7rZ9Nopql41qqs9n01bYZ2aW/v+/ehZKsQ+kI=";

  types-aiobotocore-sms-voice = buildTypesAiobotocorePackage "sms-voice" "2.12.1" "sha256-BGilumzkB01iMg0a833gBvT+LhkKVXncH/klno1Wc7g=";

  types-aiobotocore-snow-device-management = buildTypesAiobotocorePackage "snow-device-management" "2.12.1" "sha256-en4h9jzuPw1JoLLFIUVAru46YJeu9ThPYkCzcu9LyRw=";

  types-aiobotocore-snowball = buildTypesAiobotocorePackage "snowball" "2.12.1" "sha256-F8WStkw9CRkTxQXST7JKCHvJV+2DleR6zBmZmPQeCZg=";

  types-aiobotocore-sns = buildTypesAiobotocorePackage "sns" "2.12.1" "sha256-bEFE0arHc/U8LmXCiRAZkFHNWsGFb069DSseHdBJA1Y=";

  types-aiobotocore-sqs = buildTypesAiobotocorePackage "sqs" "2.12.1" "sha256-B106hChye7naXa6VvefcfDICI1rU1Td5K7zxP9vAofU=";

  types-aiobotocore-ssm = buildTypesAiobotocorePackage "ssm" "2.12.1" "sha256-f1hVxTtSmljYA3p/wNltr4wMlKT94yzP8zFIq8fHIng=";

  types-aiobotocore-ssm-contacts = buildTypesAiobotocorePackage "ssm-contacts" "2.12.1" "sha256-zhJooXRPSJoVNLRTcKMgnmGuDFvol2LCHKesveS2onI=";

  types-aiobotocore-ssm-incidents = buildTypesAiobotocorePackage "ssm-incidents" "2.12.1" "sha256-bvkyOZP9zuExuWV7ZHkV/YPzTAcl59L69TMRTkKtDKo=";

  types-aiobotocore-ssm-sap = buildTypesAiobotocorePackage "ssm-sap" "2.12.1" "sha256-YjxpS0Tn+waraHNSDKSm/Ig4axeJmUHRR9wKUh9/w8w=";

  types-aiobotocore-sso = buildTypesAiobotocorePackage "sso" "2.12.1" "sha256-pBNQzTTu3DXWoAMOZHoZwvWRZetNOEwEN6XlX5b3cTc=";

  types-aiobotocore-sso-admin = buildTypesAiobotocorePackage "sso-admin" "2.12.1" "sha256-wBv/pIRqsPxJONtGu782zxSAIDnAM6raAU8XFKoHwTQ=";

  types-aiobotocore-sso-oidc = buildTypesAiobotocorePackage "sso-oidc" "2.12.1" "sha256-HdZz0vbe+M0q5lLxArKy/k447cc2VZDByeLBkg/inl4=";

  types-aiobotocore-stepfunctions = buildTypesAiobotocorePackage "stepfunctions" "2.12.1" "sha256-J5UI5f2WWT+nhl6o0d2DkCVZKOwg5O29VbNi26RfUQ0=";

  types-aiobotocore-storagegateway = buildTypesAiobotocorePackage "storagegateway" "2.12.1" "sha256-p7ubgOcj4xkB7UcU3OUVMgzPzbLQTYcB0hbh/3KZqrs=";

  types-aiobotocore-sts = buildTypesAiobotocorePackage "sts" "2.12.1" "sha256-D/+jqiERytxUvDGxxxVBZnBQae/csg4GpRA2YAiigno=";

  types-aiobotocore-support = buildTypesAiobotocorePackage "support" "2.12.1" "sha256-7QN7ZamHv/C67SrlPWDi7yZ51QGbIr896PZ1FQ4kEuU=";

  types-aiobotocore-support-app = buildTypesAiobotocorePackage "support-app" "2.12.1" "sha256-GOdOna5aa3inSl+Q/vGPBJf3ULXmMxfabpHVvYL3XIA=";

  types-aiobotocore-swf = buildTypesAiobotocorePackage "swf" "2.12.1" "sha256-BnNcpeNmYWlmBUUgDtOczwDp/BGrjLg2+QMNJEyiCmU=";

  types-aiobotocore-synthetics = buildTypesAiobotocorePackage "synthetics" "2.12.1" "sha256-kiEkHVz9U9svw+IYstUcle1oCBSs1b2cU9vBHaY/H0c=";

  types-aiobotocore-textract = buildTypesAiobotocorePackage "textract" "2.12.1" "sha256-O95r0QCGOW2RbU1zlv4dn/1OuP/x/KFyO3TD2YwdTA8=";

  types-aiobotocore-timestream-query = buildTypesAiobotocorePackage "timestream-query" "2.12.1" "sha256-mp2zgiLO/bFBY1nhsx0nocKcerRnBzZyaONBlJ9OJk4=";

  types-aiobotocore-timestream-write = buildTypesAiobotocorePackage "timestream-write" "2.12.1" "sha256-N7FQ85Y/vr8kam/ESgTxK3v1nMnMl17wYZkcK8kOOyI=";

  types-aiobotocore-tnb = buildTypesAiobotocorePackage "tnb" "2.12.1" "sha256-bB9gINmvd69sbfqeJ5cuqhVlA52BFA26rB7c+AWXNZg=";

  types-aiobotocore-transcribe = buildTypesAiobotocorePackage "transcribe" "2.12.1" "sha256-ziN4VGQoNThnfC1Pg7thxMFzfvTE2xRGtk3f0OLRiDc=";

  types-aiobotocore-transfer = buildTypesAiobotocorePackage "transfer" "2.12.1" "sha256-Ru3p8rngnhuTytJcVycJo2w0G8hMfCWKk7bzRAU534Q=";

  types-aiobotocore-translate = buildTypesAiobotocorePackage "translate" "2.12.1" "sha256-y+b/46Qp/+iqFWdgcLhXOQQ60Jb4ZHn+T3VV2B2blr8=";

  types-aiobotocore-verifiedpermissions = buildTypesAiobotocorePackage "verifiedpermissions" "2.12.1" "sha256-Eiv4Jccs56w0k0hSKvW18vmResqvhxsLB6GmwCadPOA=";

  types-aiobotocore-voice-id = buildTypesAiobotocorePackage "voice-id" "2.12.1" "sha256-vFq5MQHyL3ShqgXGh2eBDZNq6AHVjZek+QonwuaxYwU=";

  types-aiobotocore-vpc-lattice = buildTypesAiobotocorePackage "vpc-lattice" "2.12.1" "sha256-+coxrlXSx4qwcQXf3RSOpJQL+t1yqO/xB3autVz/NLY=";

  types-aiobotocore-waf = buildTypesAiobotocorePackage "waf" "2.12.1" "sha256-U2QbBdI58XBMFEM0AYtK6i51I4lqW28Aeu+XuNhAZJ8=";

  types-aiobotocore-waf-regional = buildTypesAiobotocorePackage "waf-regional" "2.12.1" "sha256-9JjZCzf9Z8T9tQB/BE+u8+iE/kX/iMLlffBJkuNXzS0=";

  types-aiobotocore-wafv2 = buildTypesAiobotocorePackage "wafv2" "2.12.1" "sha256-2gZSrTR5wRP7qOMxkmRQqU+pH83hnEOopuVUbMIXcAU=";

  types-aiobotocore-wellarchitected = buildTypesAiobotocorePackage "wellarchitected" "2.12.1" "sha256-guUODw1ecYm396nkEoTKiYurk8YIoSJg9/IZkNaba7I=";

  types-aiobotocore-wisdom = buildTypesAiobotocorePackage "wisdom" "2.12.1" "sha256-rOa8B0/7HQ+GfmTVMq5Kn2eclN5i7ywipnJ7bYymUbA=";

  types-aiobotocore-workdocs = buildTypesAiobotocorePackage "workdocs" "2.12.1" "sha256-/hN0c65UtT9/ZgUtmrmlEoDGVUnd9rnC+hJLH38qZXw=";

  types-aiobotocore-worklink = buildTypesAiobotocorePackage "worklink" "2.12.1" "sha256-geeKa8vZebnIFuuD6Slz9ShpBYCJXrXojS2KSORDqKk=";

  types-aiobotocore-workmail = buildTypesAiobotocorePackage "workmail" "2.12.1" "sha256-ZnxR1sUOX+krBU0OKsTtnjvhPC8WnsMw4Oyfb5kbSd0=";

  types-aiobotocore-workmailmessageflow = buildTypesAiobotocorePackage "workmailmessageflow" "2.12.1" "sha256-AasaWFat0OGT4/iTmqDHnaXvFU6BQMhTpWKYc9E7FoY=";

  types-aiobotocore-workspaces = buildTypesAiobotocorePackage "workspaces" "2.12.1" "sha256-/07XwxB2vWaGR8Y07x53/C6PBTaDVKMNoSqbzaRAESo=";

  types-aiobotocore-workspaces-web = buildTypesAiobotocorePackage "workspaces-web" "2.12.1" "sha256-QBJmVHZ5UazLecUrpizJDe99t0rIllVqYw+JZQTJWBQ=";

  types-aiobotocore-xray = buildTypesAiobotocorePackage "xray" "2.12.1" "sha256-KPhRhUwIv8RG9R/skKq1hZ7SKJB18C2lWIYs4rjvjHw=";
}
