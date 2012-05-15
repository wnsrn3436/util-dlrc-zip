# 스크립트 설명

여러 파일을 `.dlrc` 파일 하나로 묶고 다시 푸는 게임메이커 8용 스크립트다. 압축은 하지 않고 묶기만 한다. 39DLL 판과 Faucet Networking 판이 있으며 두 판이 만든 `.dlrc` 파일은 서로 호환되지 않는다.

## 공통

- `dlrc_init()` : 스크립트를 초기화한다. 다른 스크립트를 사용하기 전에 한 번 호출해야 한다. 풀어낸 파일의 목록이 담길 `ds_list` 의 id 를 돌려준다. 짝수 인덱스에 파일 이름, 홀수 인덱스에 파일 크기가 들어간다.
- `dlrc_add(dlrc, count, file1, file2, ...)` : `count` 개의 파일을 `dlrc` 파일에 묶는다. `dlrc` 파일이 이미 있으면 뒤에 이어 붙이고, 없으면 새로 만든다. 묶은 뒤의 파일 개수를 돌려준다.
- `dlrc_extract(dlrc, folder, start, count)` : `dlrc` 파일에서 `start` 번째부터 `count` 개의 파일을 `folder` 에 푼다. `start` 는 0 부터 센다. `start` 가 -1 이면 전부 풀며 `count` 는 생략할 수 있다. `folder` 는 `"extract\"` 처럼 끝에 `\` 를 붙이고, 실행 파일과 같은 폴더에 풀려면 `""` 로 비운다. 푼 파일의 이름과 크기는 `dlrc_init` 이 돌려준 `ds_list` 에 들어간다. `dlrc` 파일이 없으면 `false` 를 돌려준다.

## 39DLL 판에만 있음

- `dlrc_set_estring(password)` : 본문을 암호화할 비밀번호를 정한다. `""` 이면 암호화하지 않는다. 묶을 때와 풀 때 같은 비밀번호를 써야 한다.
- `dlrc_get_fmax(dlrc)` : `dlrc` 파일 안의 파일 개수를 돌려준다.

## 변경 내역

v7.0

- 39DLL 판과 같은 내용으로 Faucet Networking 판을 만들었다. Faucet Networking 판에는 암호화와 `dlrc_get_fmax` 가 없다.
