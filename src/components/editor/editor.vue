<template>
  <div :class="$style.editorBox">
    <div :class="$style.changeTheme" v-if="!readOnly">
      <span :class="$style.title">{{title}}</span> 切换主题：
      <select v-model="currentTheme">
        <option
          v-for="(theme, index) of themes"
          :key="index"
          :value="theme"
        >{{theme}}</option>
      </select>
      切换语言：
      <select v-model="currentMode">
        <option
          v-for="(mode, index) of modes"
          :key="index"
          :value="mode"
        >{{mode}}</option>
      </select>
    </div>
    <textarea ref="editor"></textarea>
  </div>
</template>

<script>
import CodeMirror from 'codemirror'
import 'codemirror/lib/codemirror.css'
import 'codemirror/mode/vue/vue'
import themes from './themes'
import modes from './modes'
import { debounce } from 'throttle-debounce'

export default {
  props: {
    readOnly: {
      type: Boolean,
      default: false
    },
    theme: {
      type: String,
      default: '3024-day'
    },
    title: {
      type: String,
      default: ''
    },
    mode: {
      type: String,
      default: 'vue'
    }
  },
  data: (vm) => ({
    currentTheme: vm.theme,
    currentMode: vm.mode,
    themes,
    modes
  }),
  methods: {
    loadTheme (theme) {
      import(`codemirror/theme/${theme}.css`)
    },
    loadMode (mode) {
      return import(`codemirror/mode/${mode}/${mode}`)
    },
    setValue (code) {
      this.editorIns.setValue(code)
    }
  },
  watch: {
    currentTheme (theme) {
      this.loadTheme(theme)
      this.editorIns.setOption('theme', theme)
    },
    async currentMode (mode) {
      await this.loadMode(mode)
      this.editorIns.setOption('mode', mode)
    }
  },
  async mounted () {
    this.loadTheme(this.currentTheme)
    await this.loadMode(this.currentMode)
    this.editorIns = CodeMirror.fromTextArea(this.$refs.editor, {
      value: '',
      mode: this.currentMode,
      theme: this.currentTheme,
      lineNumbers: true,
      styleActiveLine: true,
      autofocus: this.readOnly ? false : true,
      readOnly: this.readOnly,
      matchBrackets: true,
      lineWrapping: true
    })
    
    this.editorIns.on(
      'change',
      debounce(500, () => {
        this.$emit('change', this.editorIns.getValue())
      })
    )
  }
}
</script>

<style lang="stylus">
.CodeMirror
  flex 1
</style>
<style lang="stylus" module>
.editor-box
  display flex
  flex-direction column
  height 100%
.title
  font-weight bold
  color green
.change-theme
  margin 10px 0
</style>
