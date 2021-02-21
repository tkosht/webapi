<template>
  <div id="app">
    <img src="./assets/logo.png" /><br />
    <!--
    <router-link to="/">トップページ</router-link>
    <router-link to="/upload">アップロードページ</router-link>
    <router-view/>
    -->
    <form id="upload_form">
      <center>
        <file-input :params="{limit: 2, unit: 'gb', allow: 'csv'}" />
      </center>
      <br />
      <button type="submit" @click="do_upload('/post?type=type_dummy')">アップロード</button>
    </form>
    <br />
    <textarea id="txtArea" ref="txtArea" v-model="response_txt" placeholder="レスポンス"></textarea>
  </div>
</template>

<script>
import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import FileInput from './components/FileInput'

Vue.config.productionTip = false
Vue.use(VueAxios, axios)

export default {
  name: 'App',
  data: function () {
    return {
      response_txt: ''
    }
  },
  components: {
    FileInput
  },
  methods: {
    do_upload: function (url) {
      var dataBody = {hello: 'こんにちは��'}

      // eslint-disable-next-line no-console
      console.log('post: ', dataBody)

      axios
        .post(url, {
          body: dataBody
        })
        .then((response) => {
          // eslint-disable-next-line no-console
          console.log('response: ', response.data)
          alert(`response: ${JSON.stringify(response.data)}`)
          // this.$refs.txtArea.value = JSON.stringify(response.data)
          this.response_txt = JSON.stringify(response.data)
        })
        .catch((error) => {
          // eslint-disable-next-line no-console
          console.log('error:' + error)
          alert(`error: ${error}`)
          // this.$refs.txtArea.value = JSON.stringify(error)
          this.response_txt = JSON.stringify(JSON.stringify(error))
        })
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

#txtArea {
  resize: vertical;
  width:300px;
  height:200px;
}
</style>
