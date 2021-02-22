<template>
  <div id="app" class="container">
    <img src="./assets/logo.png" /><br />
    <div class="row" v-if="!uploading">
      <div class="col-12 text-center">
        <form id="upload_form">
          <b-form-file
            v-model="file2Upload"
            :state="Boolean(file2Upload)"
            placeholder="Choose a file or drop it here..."
            drop-placeholder="Drop file here..."
            @input="loadSamples(file2Upload)"
          ></b-form-file>

          <p />
          <b-form-textarea
            id="textArea"
            v-model="statusText"
            placeholder="Status"
            rows="1"
            max-rows="3"
            disabled
          ></b-form-textarea>

          <p />
          <b-table sticky-header :items="sampleItems" head-variant="dark"></b-table>
          <button class="btn btn-dark" type="submit" @click="doUpload('/upload')" >Upload</button>
        </form>
      </div>
    </div>
    <div class="row" v-else>
      <div class="col-12 text-center">
          <progress ref="progress" max="100" :value.prop="uploadPercentage"></progress>
          <br>
          <span class="text-muted">Now Uploading...</span>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import axios from 'axios'
import VueAxios from 'vue-axios'
import FileInput from '@/components/FileInput'

Vue.config.productionTip = false
Vue.use(VueAxios, axios)
Vue.use(BootstrapVue, IconsPlugin)

export default {
  name: 'App',
  data: function () {
    return {
      file2Upload: null,
      uploading: false,
      sampleItems: [],
      dataItems: [],
      statusText: ''
    }
  },
  components: {
    FileInput
  },
  methods: {
    doUpload: function (url) {
      this.dataItems = []
      if (!this.file2Upload) {
        this.statusText = 'ファイルを選択してください✨'
        return {}
      }

      let formData = new FormData()
      formData.append('file', this.file2Upload)

      // eslint-disable-next-line no-console
      console.log('formData: ', formData)

      this.uploading = true

      axios
        .post(url, formData,
          {
            headers: {
              'Content-Type': 'multipart/form-data'
            },
            onUploadProgress: function (progressEvent) {
              this.progress = parseInt(Math.round((progressEvent.loaded / progressEvent.total) * 100))
            }.bind(this)
          }
        ).then((response) => {
          // eslint-disable-next-line no-console
          console.log('response: ', response.data)
          this.statusText = JSON.stringify(response.data)
        })
        .catch((error) => {
          // eslint-disable-next-line no-console
          console.log('error:' + error)
          alert(`error: ${error.message}`)
          this.statusText = error.message
        })
        .then(() => {
          this.$refs.progress.value = 0
          this.uploading = false
          this.sampleItems = []
          this.file2Upload = null
        })
    },
    loadSamples: function (csvFile) {
      this.loadCsv(csvFile, 5)
    },
    _load: function (reader, n = -1) {
      let strLines = reader.result.split('\n')
      if (n > 0) {
        strLines = strLines.slice(0, n)
      }
      let arrayLines = []
      let loops = Math.min(n, strLines.length)
      let cols = strLines[0].split(',')
      for (let i = 1; i < loops; i++) {
        let records = strLines[i].split(',')
        let recordArray = {}
        for (let j = 0; j < records.length; j++) {
          recordArray[cols[j]] = records[j]
        }
        if (!recordArray) { // posibly empty line
          continue
        }
        arrayLines.push(recordArray)
      }
      return arrayLines
    },
    loadCsv: function (csvFile, n = 10) {
      let vm = this
      vm.dataItems = []
      if (!csvFile) {
        this.statusText = ''
        return {}
      }
      // eslint-disable-next-line no-console
      console.log(csvFile)

      let reader = new FileReader()
      reader.readAsText(csvFile)

      reader.onload = () => {
        this.statusText = 'Loading ...'
        let arrayLines = this._load(reader, n)

        if (n > 0) {
          vm.sampleItems = arrayLines
          vm.dataItems = []
        } else {
          vm.sampleItems = []
          vm.dataItems = arrayLines
        }
        this.statusText = 'Loaded samples in heads of files'
      }
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

/*
#txtArea {
  resize: vertical;
  width:300px;
  height:200px;
}
*/
</style>
