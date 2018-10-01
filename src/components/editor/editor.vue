<template>
  <div style="height: 100%;">
    <div :class="$style.changeTheme">
      切换主题：
      <select v-model="currentTheme">
        <option
          v-for="(theme, index) of themes"
          :key="index"
          :value="theme"
        >{{theme}}</option>
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
    }
  },
  data: (vm) => ({
    currentTheme: vm.theme,
    themes
  }),
  methods: {
    loadTheme (theme) {
      import(`codemirror/theme/${theme}.css`)
    },
    setValue (code) {
      this.editorIns.setValue(code)
    }
  },
  watch: {
    currentTheme (theme) {
      this.editorIns.setOption('theme', theme)
      this.loadTheme(theme)
    }
  },
  mounted () {
    this.loadTheme(this.currentTheme)
    this.editorIns = CodeMirror.fromTextArea(this.$refs.editor, {
      value: '<div>asdf</div>',
      mode: 'vue',
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

<style lang="stylus" module>
.change-theme
  margin-bottom 20px
</style>
