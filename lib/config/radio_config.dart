class RadioConfig {
  static const String stationName = 'Radio Ciwara';
  static const String frequency = '105.5 FM';
  static const String city = 'Bamako';

  // URL déjà présente dans le site Radio Ciwara.
  // Elle est utilisée par le lecteur natif de l'application.
  static const String streamUrl =
      'https://uk5freenew.listen2myradio.com/live.mp3?typeportmount=s1_35628_stream_416941156';

  // Page mobile Caster/Radio12345 utilisée sur le site.
  static const String mobilePlayerUrl = 'https://ciwarafm.radio12345.com/';

  // Identifiant public du widget Caster.fm actuellement présent sur le site.
  static const String casterPublicToken =
      '236f6884-9ad2-465f-a29e-5f349a8dac8e';
}
