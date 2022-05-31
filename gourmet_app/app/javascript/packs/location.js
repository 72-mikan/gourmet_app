// Geolocation APIに対応しているかどうかの処理
let flag = document.getElementById('flag');
if (navigator.geolocation) {
  flag.value = true;
} else {
  alert("この端末では位置情報が取得できません");
  flag.value = false;
}

// 現在地を取得
navigator.geolocation.getCurrentPosition(
  // 取得成功した場合
  function(position) {
      let lat = document.getElementById('lat');
      lat.value = position.coords.latitude;
      let lng = document.getElementById('lng');
      lng.value = position.coords.longitude;
  },
  // 取得失敗した場合
  function(error) {
    switch(error.code) {
      case 1: //PERMISSION_DENIED
        alert("位置情報の利用が許可されていません");
        break;
      case 2: //POSITION_UNAVAILABLE
        alert("現在位置が取得できませんでした");
        break;
      case 3: //TIMEOUT
        alert("タイムアウトになりました");
        break;
      default:
        alert("その他のエラー(エラーコード:"+error.code+")");
        break;
    }
  }
);