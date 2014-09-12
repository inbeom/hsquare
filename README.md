# Hsquare

Hsquare는 [Kakao developers](http://developers.kakao.com) Open Platform API의
루비 클라이언트 라이브러리입니다.

현재는 푸시 알림 기능을 제공하며, 앞으로 인증 및 카카오톡, 카카오스토리 포스팅
등으로 지원 기능을 확장해 나갈 계획입니다.

## 설치하기

애플리케이션의 Gemfile에 hsquare를 추가합니다:

    gem 'hsquare'

Bundler를 이용해 설치합니다:

    $ bundle

## 사용하기

### 애플리케이션 생성

Hsquare를 사용하려면 Kakao Developers에서 애플리케이션을 생성해야 합니다.
Kakao Developers에 가입 및 로그인하신 후
[내 애플리케이션](https://developers.kakao.com/apps) 페이지에서 애플리케이션을
생성해 주세요.

### Hsquare 설정

애플리케이션 생성 후, 내 애플리케이션 페이지에서 앱 키를 얻을 수 있습니다.
4개의 앱 키 중 Admin 키를 Hsquare에 설정합니다:

```ruby
# In config/initializers/hsquare.rb

Hsquare.config do |config|
  config.admin_key = '내 애플리케이션의 Admin 키'
end
```

Admin 키는 외부에 노출되지 않도록 보안에 주의를 기울여야 합니다. 환경 변수
등으로 소스 컨트롤에서 분리하여 설정하도록 처리하는 것을 추천합니다.

### 푸시 알림

#### 기기의 푸시 토큰 등록

애플리케이션 서버에서 푸시 토큰을 등록해야 한다면 `Hsquare::Device` 클래스의
객체를 다음과 같이 생성하고,

```ruby
device = Hsquare::Device.new(
  id: 'device-1',           # 애플리케이션 내 기기 ID
  user_id: 1,               # 애플리케이션 사용자 ID
  token: 'apns-push-token', # 푸시 토큰
  type: 'apns'              # apns 또는 gcm
)
```

해당 객체의 `#register` 메소드를 호출하여 기기의 푸시 토큰을 등록할 수
있습니다.

```ruby
device.register # 기기를 등록하는 Open Platform API를 호출합니다.
```

클라이언트에서 푸시 토큰을 등록하도록 처리되어 있다면 이 과정은 거치지 않아도
됩니다.

#### 알림 전송

`Hsquare::Notification` 클래스의 객체를 생성하고 `#deliver` 메소드로 알림을
전송합니다.

`Hsquare::Notification` 클래스는 다음과 같이 생성합니다. 각 인자의 의미는 이
젬의 소스 코드나 Kakao Developers의 [API 소개 페이지](https://developers.kakao.com/docs/restapi#푸시-알림-푸시-알림-보내기)를
참조하세요:

```ruby
notification = Hsquare::Notification.new(
  recipient_ids: [1, 2, 3], # 알림을 받을 사용자 ID의 목록
  message: 'Hello world!'   # 전송할 알림 메시지
  badge: 0                  # 뱃지 카운트 (iOS only)
  sound: 'default'          # 알림 시 재생할 소리 (iOS only)
  push_alert: true          # 푸시 알림 여부 (iOS only, default: true)
  collapse: nil             # GCM collapse key (Android only)
  idle_delay: false         # 사용자 기기 상태에 따른 알림 전송 시점 변경 (Android only)
  extra: {}                 # 추가 Payload
)

notification.deliver # 알림을 전송하는 Open Platform API를 호춣합니다.
```

#### 푸시 토큰 등록 해제

기기 푸시 토큰 등록에서와 같은 방법으로 `Hsquare::Device` 객체를 생성하고 해당
객체의 `#unregister` 메소드를 호출하여 기기의 푸시 토큰을 등록 해제할 수
있습니다.

## Contributing

1. Fork it ( https://github.com/inbeom/hsquare/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
