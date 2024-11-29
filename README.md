![LogoTravelHunter](./prototipo_movil_proyecto/assets/images/logo_principal.png)

## Technologies used

[![Flutter](https://img.shields.io/badge/Flutter-28B0EE?style=for-the-badge&logo=flutter&logoColor=0C4B33&labelColor=ffffff)](https://flutter.dev/)
[![Geolocator Package](https://img.shields.io/badge/Geolocator_Package-28B0EE?style=for-the-badge&logo=dropbox&logoColor=0C4B33&labelColor=ffffff)](https://pub.dev/packages/geolocator)
[![Google Maps](https://img.shields.io/badge/Google_Maps_API-EA4335?style=for-the-badge&logo=googlemaps&logoColor=0C4B33&labelColor=ffffff)](https://developers.google.com/maps/apis-by-platform?hl=es-419)

## Mobile Design

[![Canva Design](https://img.shields.io/badge/Mobile_Design-31648C?style=for-the-badge&logo=canva&logoColor=396EE3&labelColor=ffffff)](https://www.canva.com/design/DAFnPbtpbJI/KtkUCN3BwjVlGPyVV8af0A/view?utm_content=DAFnPbtpbJI&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink)

# Mobile Prototype App

Mobile prototype application to be used by the users of a travel agency. It works alongside the web application, as this application will get all the information from the web application's API.

The mobile application implements these main modules:

- __Login__: The user must log in with credentials to access the application.

  ![login](./prototipo_movil_proyecto/assets/images/login.png)
---
- __User's Module__: Shows the user's information and allows the user to update it.

  ![user screen](./prototipo_movil_proyecto/assets/images/profile.png)
  ![user edit screen](./prototipo_movil_proyecto/assets/images/profile_edit.png)
---
- __Trips Module__: Shows the trips the user has taken and the active trip if there is one.

  ![trips screen](./prototipo_movil_proyecto/assets/images/trips.png)
  ![active trip screen](./prototipo_movil_proyecto/assets/images/trip_active.png)
  ![trip places screen](./prototipo_movil_proyecto/assets/images/trip_places.png)
  ![trip place details screen](./prototipo_movil_proyecto/assets/images/trip_place_detail.png)
---
- __Products Module__: Shows the products offered by the travel agency and allows the user to send an appointment to the travel agency through mail.

  ![products screen](./prototipo_movil_proyecto/assets/images/products.png)
  ![product detail screen](./prototipo_movil_proyecto/assets/images/product_details.png)
  ![product place detail screen](./prototipo_movil_proyecto/assets/images/product_place_details.png)
  ![product appointment screen](./prototipo_movil_proyecto/assets/images/product_appointment.png)
---
- __Benefits Module__: Shows the benefits offered by the travel agency by completing different gamified activities inside the application.

  ![benefits screen](./prototipo_movil_proyecto/assets/images/benefits.png)
  ![benefit questions screen](./prototipo_movil_proyecto/assets/images/benefit_questions.png)
  ![benefit pictures screen](./prototipo_movil_proyecto/assets/images/benefit_pictures.png)
  ![benefit camera screen](./prototipo_movil_proyecto/assets/images/benefit_camera.png)
---

This application makes use of the Google Maps API to show the specific location of each place of a trip.

There is also a gamified module that allows the user to get benefits by completing different interactions inside the application.
- __Progress Benefits__: The user will get points by answering questions about the country they are visiting. The user will get a benefit when they reach a certain amount of points.
- __Achievements Benefits__: The user must take a picture of an specific place set by the travel agency. The user will get a benefit when the travel agency validates the picture.

The web application developed in Django can be found in this [repository](https://github.com/ElyRiven/Prototipo-Web-Proyecto).