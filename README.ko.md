# DLRC Zip

게임메이커 8용 아카이브 라이브러리다. 여러 파일을 `.dlrc` 파일 하나로 묶고 다시 푸는 스크립트 모음으로, 포맷은 직접 설계했다. 기존 아카이브에 파일을 이어 붙이는 것과 일부만 골라 푸는 것, 본문 암호화를 지원한다. 이름은 Zip이지만 압축은 하지 않고 묶기만 한다. 파일 입출력을 맡기는 확장에 따라 39DLL 버전과 Faucet Networking 버전 두 가지를 냈다.


## 사용 방법

Releases에서 받은 압축 파일에는 두 버전 각각의 스크립트 리소스(`.gmres`), 확장(`.gex`), 예제가 들어 있다. 쓰려는 확장을 게임메이커 8에 설치하고 `File > Import Resources` 로 리소스를 불러온다.

```gml
list = dlrc_init()                          // 한 번만. 추출 결과가 담길 ds_list 를 돌려준다
dlrc_set_estring("12345")                   // 39DLL 버전만. 비워두면 암호화하지 않는다

dlrc_add("data.dlrc", 2, "target1.exe", "target2.txt")   // 파일 2개를 묶는다. 이미 있으면 뒤에 이어 붙인다
dlrc_extract("data.dlrc", "extract\", -1)                // 전부 푼다
dlrc_extract("data.dlrc", "extract\", 1, 1)              // 1번부터 1개만 푼다
```

`dlrc_extract` 가 끝나면 `dlrc_init` 이 돌려준 리스트에 푼 파일의 이름과 크기가 번갈아 들어간다. `dlrc_get_fmax` 는 아카이브 안 파일 개수만 읽는다. 스크립트 전체의 인자 설명은 [docs/reference.ko.md](docs/reference.ko.md) 에 있다.


## 구현 원리

**포맷은 개수, 본문, 크기 표 세 부분이다.**

```
[파일 개수 4byte] [파일명 + 내용] [파일명 + 내용] ... [크기 4byte] [크기 4byte] ...
```

맨 앞 4byte가 파일 개수이고 맨 뒤에 파일 개수만큼 4byte 크기가 이어진다. 크기 표가 뒤에 있어서 파일을 이어 붙일 때 본문 뒤에 새 파일을 더하고 표만 다시 쓰면 된다. 부분 추출은 앞 파일들을 크기만큼 건너뛰는 것으로 끝난다.

```gml
// dlrc_add 끝부분: 개수 뒤에 본문을 붙이고 크기 표를 쓴다
dll39_buffer_copy(global.dlrc_buffer_id_, global.dlrc_buffer_id2_)
for(i=0; i!=temp_size_max; i+=1){dll39_write_uint(temp_size[i], global.dlrc_buffer_id_)}
dll39_file_write(temp_file, global.dlrc_buffer_id_)
```

**본문만 암호화한다.** 39DLL 버전은 비밀번호가 있으면 파일명과 내용이 든 본문을 `dll39_buffer_encrypt` 로 감싼다. 개수와 크기 표는 평문으로 남기므로 파일이 몇 개고 각각 몇 바이트인지는 보이지만 이름과 내용은 비밀번호 없이 못 읽는다. 이어 붙일 때는 기존 본문을 풀어서 새 파일을 더한 뒤 다시 감싼다.

**두 버전은 파일명 저장 방식이 다르다.** 39DLL 버전은 파일명을 null 종료 문자열로 적고, Faucet Networking 버전은 길이 4byte 뒤에 문자열을 적는다. 그래서 두 버전이 만든 아카이브는 서로 호환되지 않는다. Faucet Networking 버전에는 암호화와 `dlrc_get_fmax` 가 없다.


## 파일

| 경로 | 내용 |
|---|---|
| `source/39dll/dlrc-zip-39dll.gmk` | 39DLL 버전 프로젝트 파일 |
| `source/39dll/split/` | GmkSplitter로 분해한 텍스트 트리 |
| `source/39dll/39dll_Ext.gex` | 39DLL 확장 |
| `source/fn/dlrc-zip-fn.gmk` | Faucet Networking 버전 프로젝트 파일 |
| `source/fn/split/` | GmkSplitter로 분해한 텍스트 트리 |
| `source/fn/Faucet Networking v1.4.2.gex` | Faucet Networking 확장 |
| `docs/reference.ko.md` | 스크립트 설명 |
| Releases | 두 버전의 스크립트 리소스, 확장, 예제 |


## 크레딧

39DLL은 게임메이커 커뮤니티에서 널리 쓰인 파일·네트워크 DLL로 39ster가 만들었다. Faucet Networking은 Medo42가 만든 게임메이커용 네트워크·버퍼 확장이다.


## 라이선스

zlib 라이선스다. 자세한 내용은 [LICENSE](LICENSE) 에 있다. 함께 들어 있는 것 중 다른 사람이 만든 라이브러리는 각자의 라이선스를 따른다.
