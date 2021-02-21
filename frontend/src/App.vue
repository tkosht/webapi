<template>
  <div id="app">
    <img src="./assets/logo.png"><br>
    <!--
    <router-link to="/">トップページ</router-link>
    <router-link to="/upload">アップロードページ</router-link>
    <router-view/>
    -->
    <form id="upload_form">
      <file-input :params="{limit: 2, unit: 'gb', allow: 'csv'}" />
        <button type="submit" @click="do_upload">アップロード</button>
    </form>
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
  components: {
    FileInput
  },
  methods: {
    do_upload: function () {
      console.log('do_upload')
      axios.post('/post', {
        data: {hello: 'こんにちは世界'}
      })
        .then(response => {
          console.log('response: ' + JSON.stringify(response.data.data))
        }).catch(error => {
          console.log('error:' + error)
        })
    }
  }
}
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
