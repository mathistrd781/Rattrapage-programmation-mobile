String getWeatherIcon(int code) {
  if (code == 0) {
    return 'assets/icons/sunlight.svg';
  } else if ([1, 2, 3].contains(code)) {
    return 'assets/icons/cloudy-1.svg';
  } else if ([45, 48].contains(code)) {
    return 'assets/icons/haze.svg';
  } else if ([51, 53, 55].contains(code)) {
    return 'assets/icons/rain-drops-1.svg';
  } else if ([56, 57].contains(code)) {
    return 'assets/icons/snow-1.svg';
  } else if ([61, 63, 65].contains(code)) {
    return 'assets/icons/rain.svg';
  } else if ([66, 67].contains(code)) {
    return 'assets/icons/snow-2.svg';
  } else if ([71, 73, 75].contains(code)) {
    return 'assets/icons/snow.svg';
  } else if (code == 77) {
    return 'assets/icons/snow-3.svg';
  } else if ([80, 81, 82].contains(code)) {
    return 'assets/icons/rain-wind.svg';
  } else if ([85, 86].contains(code)) {
    return 'assets/icons/snow.svg';
  } else if (code == 95) {
    return 'assets/icons/thunderstorm.svg';
  } else if ([96, 99].contains(code)) {
    return 'assets/icons/thunderstorm.svg';
  } else {
    return 'assets/icons/cloud.svg'; // Default icon
  }
}
