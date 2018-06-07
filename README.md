# Exercice 5/01

Cet exercice vous permettra de réaliser des vues avec JSTL et la taglib spring-form.  
Il est réalisable sans utiliser les éléments des exercices précédants.

Le pom reprend les dépendance d'un projet spring-webmvc classique.

* Ajouter une dépendance vers l'artefact jstl du groupe javax.servlet en version 1.2, dans le scope runtime

Le contexte Spring est déjà configuré via l'objet fr.eservices.drive.web.AppConfig


## Implémenter le contrôleur panier

Ouvrez la classe CartController.

* Implémentez la méthode getCart.  
  Vous lancerez une DataException si l'identifiant du panier est inférieur ou égal à 0.  
  Cette méthode sera appelée en "ajax" et renverra uniquement le morceau de html utile à l'affichage du contenu du panier.
* Ce contrôleur propose un ExceptionHandler sur le type d'exception DataException.  
  Observez les annotations placée et le comportement de ce Handler.
* Ouvrez  le fichier exo501/src/main/webapp/js/cart.js  
  Ce javascript est exécuté pour afficher le contenu du panier dans l'entête du site, sur le menu "panier" ouvert en dropdown.  
  Notre Dao (un mock) ne propose pour le moment que le contenu du panier "1", modifiez le dernier appel ajax pour afficher le panier 1.  
* packagez l'application et lancez tomcat.
* Accédez à http://localhost:8080/exo501/sample_products.jsp  
  Cette page est une liste de produits fixes. Elle fait maintenant un appel au panier "1" et l'affiche dans le menu.  
  La vue utilisée pour le menu est elle-aussi fixe pour le moment.
  

## Implémentez la vue panier

Complétez la vue "_cart_header.jsp" pour afficher la liste des produits du panier.

Pour chaque produit, on affichera :

* son nom
* son prix au format "X,XX €"  
  vous pouvez utiliser la taglib fmt et la fonction formatNumber pour cela, avec un type currency et une valeur "{$art.price / 100.0}" par exemple.

Si le panier ne contient aucun article affichez "aucun article".

Ce morceau de vue est chargé à la suite de l'affichage de la page sample_product, par un appel réalisé en javascript.  
Le contenu html est alors placé dans le menu.  
C'est une technique assez utilisée pour injecter du contenu dynamique dans une partie de html commune, ou pour éviter de recharger toute la page si le contenu est modifié.

Le contenu du panier est donc aussi disponible via l'adresse http://localhost:8080/exo501/cart/1.html


## Implémentez la fonction d'ajout de produit

* Complétez la fonction add de CartController.  
  Cette fonction est appelée en ajax, elle reçoit un objet CartEntry qui est construit à partir d'un objet JSON reçu dans le corps de la requête HTTP Post.  
  C'est jQUery qui est utilisé dans le script cart.js qui se charge d'effectuer l'appel à ce contrôleur.
* Renvoyer une status d'erreur si :  
  - produit n'existe pas, 
  - la quantité est strictement inférieure à 0
* Vous devriez ajouter les produits présentés sur la page sample_products au Mock pour tester votre implémentation.
* Essayez de mettre à jour le panier lorsque vous recevez un status OK.  
  Prenez modèle sur l'appel initial d'affichage du panier.

## Implémentez la fonction de validation du panier

Cette fonction doit créer une commande à partir du panier, en prenant chaque article et en l'associant à la commande.  
Afin de fixer le montant du panier à la valeur des articles au moment de la commande, il faudra calculer la somme des prix de chaque article.  

L'objectif est de compléter la fonction validate du controleur CartController.  
Plutot que d'implémenter une classe sur OrderDao, essayez d'utiliser un CrudRepository :
  
* déclarez un contexte de persistance JPA en écrivant un fichier de persistance,
* ajoutez les dépendances vers :  
  - Hibernate-core comme implémentation de JPA,  
  - H2 pour pouvoir persister vos données,  
  - spring-data-jpa ( org.springframework.data : spring-data-jpa : 1.11.8.RELEASE )
* Il faut exposez l'entityManagerFactory dans le contexte via un Bean déclaré dans AppConfig,  
  utilisez un LocalContainerEntityManagerFactoryBean et nommez le entityManagerFactory.
* Il faut aussi exposer un PlatformTransactionManager de type JpaTransactionManager nommé "transactionManager".    
  n'hésitez pas à regarder (cette partie du screencast)[https://www.youtube.com/watch?v=9cyJWGng-iA#t=2m35s] pour suivre la démarche. 
* faîtes une extension de CrudRepository avec les bons types génériques sur OrderRepository
* activer les JpaRepository en plaçant l'annotation @EnableJpaRepository sur AppConfig,  
  indiquez le package dans lequel se trouve le(s) interfaces dont vous souhaitez générer les implémentations.
* placer une référence de OrderRepository dans le CartController, à la place de orderDao et placez l'annotation @Autowired.  
  Vous pouvez maintenant utiliser ce repository pour créer une commandes à partir d'un panier.  
  Complétez la méthode validateCart, vous pouvez utilisez l'identifiant "chuckNorris" pour lier à un client factice.    
  Assignez le status "ORDERED" comme état initial de cette commande.
* A la fin du traitement rediriger l'utilisateur vers la liste des commandes de "chuckNorris".

## Implémentez la liste des commandes

Implémentez la méthode list du OrderController.

* Recherchez les commandes avec le OrderRepository à injecter dans ce contrôleur,  
  pour cela ajouter une méthode dans ce repository pour rechercher toutes les commandes d'un client,
  ordonnées par date décroissante ce commande.
* Affectez ces commandes à "orders" dans le Model 
* Cette méthode de contrôleur pointera sur la vue order_list.jsp

Implémentez la vue order_list.jsp

* Itérez sur chaque commande
* Afficher la date de la commande, le montant et le status actuel

  

## Pour aller plus loin

* Utilisez un panier propre à chaque visiteur
* Modifiez les vues et contrôleurs pour prendre en compte cette modification
* Lors de la validation de commande, assigner un nouveau panier au visiteur
* Essayez de ré-intégrer le contenu des précédants exercices pour avoir l'ensemble des fonctions du Drive implémentées jusqu'ici.  


## Déployer sur Héroku

(Heroku)[https://www.heroku.com/] est une plateforme offrant des services d'hébergement d'application Node, Ruby, Java, Php, python ...

Heroku offre un service freemium vous permettant de déployer de petites applications gratuitement.  
Nous décrivons ici, brièvement, la procédure pour déployer votre projet sur heroku.  
Heroku met à votre disposition un dépot de source git. C'est à travers les mises à jour de ce dépot que heroku va déployer votre application après chaque mise à jour (push).  

N'hésitez pas à consultez la documentation générale de Heroku ou la partie dédié au déploiement d'application web java :  
https://devcenter.heroku.com/articles/java-webapp-runner



- Créer un compte sur heroku :  
https://signup.heroku.com/login
- Téléchargez et installez le CLI heroku pour votre système :  
https://devcenter.heroku.com/articles/heroku-cli#download-and-install
- Ouvrez la console et identifiez vous sur heroku : ```heroku login```
- placez vous dans le répertoire de votre projet et initialisez un repo git : ```git init```
- ajoutez vos sources : ```git add src```
- créez un fichier Procfile contenant :  
```
web: java $JAVA_OPTS -jar target/dependency/webapp-runner.jar --port $PORT target/*.war
```
- ajoutons le lanceur d'application "webapp" dans le pom.xml :
```
<build>
  <plugins>
      <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-dependency-plugin</artifactId>
          <version>3.0.2</version>
          <executions>
              <execution>
                  <phase>package</phase>
                  <goals><goal>copy</goal></goals>
                  <configuration>
                      <artifactItems>
                          <artifactItem>
                              <groupId>com.github.jsimone</groupId>
                              <artifactId>webapp-runner</artifactId>
                              <version>8.5.27.0</version>
                              <destFileName>webapp-runner.jar</destFileName>
                          </artifactItem>
                      </artifactItems>
                  </configuration>
              </execution>
          </executions>
      </plugin>
  </plugins>
</build>
```
- ajoutez le pom.xml et le Procfile aux sources git : ```git add Procfile pom.xml```
- commitez ces modifications : ```git commit -m "Deploying to heroku"```
- créez une application heroku : ```heroku create```  
Héroku vous fournit à ce moment là l'url du dépot git associé à votre projet. Copiez la pour la commande suivante.   
- ajoutez le repo distant heroku :```git add heroku https://high-lightning-129.herokuapp.com/```  
en remplaçant évidemment par l'url de votre dépot.
- poussez vos modifs sur heroku : ```git push heroku master```  
Héroku devrait alors construire votre projet et le déployer.  
Il est maintenant accessible à travers l'url fournie auparavant. Pensez simplement à y ajouter le nom du contexte web, exemple ```/exo501```



