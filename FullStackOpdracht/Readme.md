# Beste Solicitant

In deze folder vind je de opzet van jouw opdracht, in de src map zitten een angular aspnet core project, deze heeft naast de default de volgende configuraties:

Daarnaast hebben we in onze Azure omgeving een account aangemaakt voor jou, en een resource group gecreëerd met en verschillende resources.

## Applicatie deployen

Voordat je de applicatie kan deployen moet je ingelogd zijn bij azure.

```ps
az login
```

De applicatie kan gebouwd en gedeployed worden met de volgende commands:

```ps
$tag = "<tag>"
cd src
az acr build -r acrforgedemowf6edetest -t forgedemo:$tag .
az deployment group create -g rg-fullstackopdracht -f ../.infrastructure/main.bicep --parameters ../.infrastructure/parameters.json --parameters tag=$tag
```

## De Opdracht

1. Gebruik de [forge documentatie](https://learnforge.autodesk.io/#/) om de huidige applicatie uit te breiden en het mogelijk te maken om een ifc file in te lezen.  

2. Gebruik de [forge documentatie](https://learnforge.autodesk.io/#/) om de ifc te kunnen viewen.

3. Maakt script om het deployen van deze applicatie eenvoudiger te maken.
