<template>
  <div id="app" :class="$style.vcpView">
    <section :class="[$style.editorWrap, $style.editableWrap]">
      <editor
        @change="handleEditorChange"
        title="编辑器-输入Vue模板"
      />
    </section>
    <section :class="[$style.editorWrap, $style.uneditableWrap]">
      <div :class="$style.changeTypeButton">
        切换展示信息：
        <select v-model="displayType">
          <option v-for="(val, key) of types" :key="key" :value="key">{{val}}</option>
        </select>
      </div>
      <div
        :class="$style.childEditor"
        v-for="(type, key) of types"
        v-show="displayType === key"
        :key="key"
      >
        <editor
          :title="type"
          :read-only="true"
          theme="ambiance"
          mode="javascript"
          :ref="`${key}Editor`"
        />
      </div>
    </section>
  </div>
</template>

<script>
import Editor from '@/components/editor/editor'
import { compile } from 'vue-template-compiler'

const types = {
  ast: '抽象语法树(AST)',
  render: '渲染函数(render)',
  staticRenderFns: '静态渲染函数(staticRenderFns)',
  errors: '编译错误信息(errors)'
}

export default {
  name: 'app',
  data: () => ({
    displayType: 'ast',
    types,
    res: ''
  }),
  components: {
    Editor
  },
  watch: {
    displayType: 'setEidtorValue'
  },
  methods: {
    handleEditorChange (code) {
      this.res = compile(code, {
        comments: true
      })
      this.setEidtorValue(this.displayType)
    },
    setEidtorValue (type) {
      this.$nextTick(() => {
        switch (type) {
          case 'ast':
            this.$refs.astEditor[0].setValue(this.formatJSON(this.res.ast))
          break
          case 'render':
            this.$refs.renderEditor[0].setValue(this.res.render)
          break
          case 'staticRenderFns':
            this.$refs.staticRenderFnsEditor[0].setValue(this.formatJSON(this.res.staticRenderFns))
          break
          case 'errors':
            this.$refs.errorsEditor[0].setValue(this.formatJSON(this.res.errors))
          break
        }
      })
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
  margin 0
}
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
.uneditable-wrap
  display flex
  flex-direction column
.child-editor
  flex 1
.change-type-button
  margin 10px 0
</style>
