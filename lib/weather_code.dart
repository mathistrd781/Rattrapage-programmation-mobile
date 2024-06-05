String translateWeatherCode(int code) {
  if (code == 0) {
    return 'Ciel dégagé';
  } else if ([1, 2, 3].contains(code)) {
    return 'Principalement clair';
  } else if ([45, 48].contains(code)) {
    return 'Brouillard';
  } else if ([51, 53, 55].contains(code)) {
    return 'Bruine';
  } else if ([56, 57].contains(code)) {
    return 'Bruine verglaçante';
  } else if ([61, 63, 65].contains(code)) {
    return 'Pluie';
  } else if ([66, 67].contains(code)) {
    return 'Pluie verglaçante';
  } else if ([71, 73, 75].contains(code)) {
    return 'Chute de neige';
  } else if (code == 77) {
    return 'Grains de neige';
  } else if ([80, 81, 82].contains(code)) {
    return 'Averses de pluie';
  } else if ([85, 86].contains(code)) {
    return 'Averses de neige';
  } else if (code == 95) {
    return 'Orage';
  } else if ([96, 99].contains(code)) {
    return 'Orage avec grêle';
  } else {
    return 'Code météo inconnu';
  }
}
