# FireStore

un paquete que nos ayuda a poder conectarnos desde R a una colección de Firebase (Cloud Firestore)  y poder descargar para manipular la data 
 
 
### Pre-requisitos 📋

  httr (>= 1.2.1),
  jsonlite (>= 	1.4),
  curl (>= 2.3),
  httpuv (>= 1.5.2)





### Instalación 🔧

solo necesitamos instalar el paquete **fireStore**

```
install.packages("fireStore")
library("FireStore")
```

antes de utilizarlo necesitamos instalar los siguientes paquetes

```
install.packages("tractor.base")
library("tractor.base") 
install.packages("httr")
library("httr")
install.packages("httpuv")
library("httpuv")
install.packages("jsonlite")
library("jsonlite")
install.packages("curl")
library("curl")
```

## Como ejecutar 🔩

primero debemos obtener un token para acceder a firebase y para ello debes ir a console.developers.google.com  y obtener  CLIENT ID Y CLIENT SECRET 

Nos autentificamos
```
auth <- fireStore.google_firestore("xxxxxxxxxxxxxxxxxx.apps.googleusercontent.com","-xxxxxxxxxxxxx") 
```

Podemos descargar Colección
```
data <- fireStore.download("mi-proyecto-2112" , "miColeccion",auth$credentials$access_token ,"D://data.rds")
```

Podemos hacer un conteo de una Colección
```
fireStore.count("mi-proyecto-6465" , "miColeccion", auth$credentials$access_token)
```

## Soporte 📖

* **Luis Rodriguez** - *Digital Analytics Engineer* - <lrodriguez@attachmedia.com> - (https://luisrodriguez.pe) 

## Autores ✒️

* **Luis Rodriguez** - *Digital Analytics Engineer* - <lrodriguez@attachmedia.com> - (https://luisrodriguez.pe) 


## Licencia 📄

**GPL-3**

## Sponsors

![fireStore](https://image.prntscr.com/image/GZc4BL92SOix1qVBgiPVRg.png)

