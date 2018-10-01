<template>
  <div id="app" :class="$style.vcpView">
    <section :class="[$style.editorWrap, $style.editableWrap]">
      <editor @change="handleEditorChange"/>
    </section>
    <section :class="$style.editorWrap">
      <editor
        :read-only="true"
        theme="ambiance"
        ref="displayEditor"
      />
    </section>
  </div>
</template>

<script>
import Editor from '@/components/editor/editor'
import { compile } from 'vue-template-compiler'

export default {
  name: 'app',
  components: {
    Editor
  },
  methods: {
    handleEditorChange (code) {
      const res = compile(code, {
        comments: true
      })
      this.$refs.displayEditor.setValue(this.formatJSON(res.ast))
    },
    formatJSON (json) {
      if (!json) return ''
      const cache = []
      return JSON.stringify(json, (key, value) => {
        if (typeof value === 'object' && value !== null) {
          if (cache.indexOf(value) !== -1) {
            return '[循环引用]'
          }
          cache.push(value)
        }
        return value
      }, 4)
    }
  }
}
</script>

<style lang="stylus">
html, body {
  height 100%
}
.CodeMirror
  height 100%
</style>

<style lang="stylus" module>
.vcp-view
  display flex
  height 100%
.editable-wrap
  margin-right 50px
.editor-wrap
  flex 1
  flex-shrink 0
</style>
