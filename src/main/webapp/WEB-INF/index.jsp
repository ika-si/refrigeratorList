<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <!-- Bootstrap の css をインポートする。参考 https://getbootstrap.jp/docs/4.5/getting-started/introduction/　-->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
  <!-- モバイルブラウザでのレイアウトを制御する。参考 https://qiita.com/ryounagaoka/items/045b2808a5ed43f96607 -->
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui">
  <!-- 検索エンジンに引っかからないようにする。参考 https://ameblo.jp/masa30201/entry-11564231810.html -->
  <meta name="Keywords" content="norobot">
  <!-- jQuery, Bootstrap の JSライブラリ をロードする。参考 https://getbootstrap.jp/docs/4.5/getting-started/introduction/ -->
  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
  <!-- android のブラウザを全画面表示にさせる -->
  <meta name="mobile-web-app-capable" content="yes">
  <!-- iOS のブラウザを全画面表示にさせる -->
  <meta name="apple-mobile-web-app-capable" content="yes">
  <title>RefrigeratorList</title>
  <!-- CSS の定義 -->
  <style>
   /*  文字の色を指定 */
  .fontBlue {
    color: blue;
  }
  .fontRed {
    color: red;
  }
  </style>
</head>
<body>
  <!-- ナビゲーションバーの配置。参考 https://getbootstrap.jp/docs/4.5/components/navbar/ -->
  <nav class="navbar navbar-dark bg-primary">
    <span class="navbar-brand mb-0 h1">RefrigeratorList</span>
  </nav>
  <!-- container はグリッドシステムを活用するために必要な定義。参考 https://getbootstrap.jp/docs/4.5/layout/overview/#containers -->
  <div class="container">
    <div class="row mx-auto">
      <div class="col">
        <form class="form-inline">
          <!-- グリッドシステムを利用した幅の定義。参考 https://getbootstrap.jp/docs/4.5/layout/grid/ -->
          <div class="form-group md-6 sm-5 mt-4 mb-4 mr-2 col-xs-10">
            <input type="text" class="form-control" placeholder="食材を入力" id='taskNameForAdd'>
          </div>
          <div class="form-group md-6 sm-5 mt-4 mb-4 mr-2">
            <button type="button" class="btn btn-primary" id="addBtn" onclick="add()">Add</button>
          </div>
        </form>
      </div>
    </div>
    <!-- タスクをリスト表示するための場所 -->
    <div id="list"></div>
    <!-- Modalの作成。参考 https://getbootstrap.jp/docs/4.5/components/modal/ -->
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="editModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalTitleLabel">Edit</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <div class="form-group mx-sm-3 mb-2">
              <input type="hidden" id="docId"> <!-- 選択したタスクIDを管理するための部分。画面上では非表示になる。 -->
              <input type="text" id="taskNameForEdit" placeholder="Task Name">
              <p id='warningMsg'>本当に削除してもよろしいですか？</p>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button type="button" id="updateBtn" class="btn btn-success" onclick="update()">Update</button>
            <button type="button" id="deleteBtn" class="btn btn-danger" onclick="del()">Delete</button>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script>
// タスクを追加する
function add(){
  let taskNameForAdd = $("#taskNameForAdd").val(); // inputbox に入力された値を取得する
  if (taskNameForAdd == "") return; // もし、inputbox が空だった場合は関数を終了する
  create_at = new Date() // 現在時刻
  $("#taskNameForAdd").val(''); // inputbox に入力された値を空にする
  num = 0;
  status = false;
  $('#list').append(' \
	      <div class="row mx-auto"> \
	        <div class="col-sm"> \
	          <form class="form-inline"> \
	            <div class="custom-control custom-checkbox"> \
	              <input type="checkbox" class="custom-control-input" id="customCheck' + num + '" ' + status + ' onclick="check(this);"> \
	              <label class="custom-control-label" for="customCheck' + num + '"> \
	                <p>' + taskNameForAdd + '\
	                  [<a data-toggle="modal" data-target="#editModal" onclick="showEditModal(this)"> <span class="fontBlue">edit</span> </a>] \
	                  [<a data-toggle="modal" data-target="#editModal" onclick="showDeleteModal(this)"> <span class="fontRed">x</span> </a>] \
	                </p> \
	                <p>' + create_at + '</p> \
	              </label> \
	            </div> \
	          </form> \
	        </div> \
	      </div>'
	      );
}
// タスクを削除する
function del(){
  db.collection("tasks").doc($('#docId').val()).delete() // $('#docId').val() で削除する対象データのIDを取得し、そのデータに対して削除を行う
    .then(function() { // 成功した場合に実行される箇所
      console.log("Document successfully deleted!");
      $('#list').text = "" // タスクをリスト表示するための箇所（<div id="list"></div>）を空文字に設定（初期化）
      $("#editModal").modal('toggle'); // Modal の表示を OFF にする
      getAll(); // 保持されている全てのタスクデータを取得し、表示する
  }).catch(function(error) { // 失敗した場合に実行される箇所
      console.error("Error removing document: ", error);
  });
}
// タスクを更新する
function update(){
  let taskNameForEdit = $("#taskNameForEdit").val(); // inputbox に入力された値を取得する
  if (taskNameForEdit == "") return; //　もし、inputbox が空だった場合は関数を終了する
  collection = db.collection("tasks").doc($('#docId').val()).update({ // $('#docId').val() で削除する対象データのIDを取得し、そのデータに対して更新を行う
    name: taskNameForEdit, // 入力されたタスク名
  }).then(function() { // 成功した場合に実行される箇所
      console.log("Document successfully updated!");
      $('#list').text = "" // タスクをリスト表示するための箇所（<div id="list"></div>）を空文字に設定（初期化）
      $("#editModal").modal('toggle'); // Modal の表示を OFF にする
      getAll(); // 保持されている全てのタスクデータを取得し、表示する
      $("#taskNameForEdit").val(''); // inputbox に入力された値を空にする
  }).catch(function(error) { // 失敗した場合に実行される箇所
      console.error("Error removing document: ", error);
  });
}
// タスクの完了、未完了を制御する
function check(elm) {
  db.collection("tasks").doc(elm.getAttribute('value')).update({ // elm.getAttribute('value') で削除する対象データのIDを取得し、そのデータに対して更新を行う
    done: elm.checked, // 対象要素のチェック状態
  }).then(function() { // 成功した場合に実行される箇所
      console.log("Document successfully updated!");
  }).catch(function(error) { // 失敗した場合に実行される箇所
      console.error("Error removing document: ", error);
  });
}
// タスク更新のためのモーダルを表示する
function showEditModal(elm) {
  $('#docId').val(elm.getAttribute('value')); // 選択したタスクデータのID を <input type="hidden" id="docId"> に設定
  $('#updateBtn').css("display","inline"); // 更新用のボタンを表示する
  $('#deleteBtn').css("display","none"); // 削除用のボタンを非表示にする
  $('#taskNameForEdit').css("display","inline"); // タスク名を入力するための inputbox を表示する
  $('#warningMsg').css("display","none"); // 削除用の警告メッセージを非表示にする
}
// タスク削除のためのモーダルを表示する
function showDeleteModal(elm) {
  $('#docId').val(elm.getAttribute('value')); // 選択したタスクデータのID を <input type="hidden" id="docId"> に設定
  $('#updateBtn').css("display","none"); // 更新用のボタンを非表示にする
  $('#deleteBtn').css("display","inline"); // 削除用のボタンを表示する
  $('#taskNameForEdit').css("display","none"); // タスク名を入力するための inputbox を非表示にする
  $('#warningMsg').css("display","inline"); // 削除用の警告メッセージを表示する
}
  </script>
</body>
</html>