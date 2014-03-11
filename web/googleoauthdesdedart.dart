import "dart:html";
import "package:google_oauth2_client/google_oauth2_browser.dart";
import 'dart:convert';

void main() {
  var botonLogin = new ButtonElement();
  botonLogin.text = "Loguearse con Google+";
  botonLogin.classes.add('googleSignInButton');
  botonLogin.id = "boton_login";
  botonLogin.onClick.listen((_) {   
    googleLogin.login();
  });
  document.body.children.add(botonLogin);
}

final googleLogin = new GoogleOAuth2(
    "INTRODUZCA_CLIENT_ID_AQUI", // Client ID
    ["openid", "email"],
    tokenLoaded:loginCallback);

void loginCallback(Token clave) {
    final googlePlusURL = "https://www.googleapis.com/plus/v1/people/me";
    var request = new HttpRequest();
    request.open("GET", googlePlusURL);
    request.setRequestHeader("Authorization", "${clave.type} ${clave.data}");
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 200 || request.status == 0)) {
        imprimirPerfil(request.responseText);
      }
    });
    request.send();
}

void imprimirPerfil(perfil) {
  querySelector("#boton_login").remove();
  final miPerfil = JSON.decode(perfil);
  querySelector("#perfil_nombre").text = miPerfil['displayName'];
  querySelector("#perfil_email").text = miPerfil['emails'][0]['value'];
  querySelector("#perfil_imagen").setAttribute('src', miPerfil['image']['url']);
  querySelector("#perfil_url").setAttribute('href', miPerfil['url']);
  querySelector("#perfil_url").text = miPerfil['url'];
}
