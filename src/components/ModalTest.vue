<template>
  <q-modal class="minimized" ref="basicModal">
    <p>Basic Modal</p>
    <button class="primary" @click="$refs.basicModal.close()">Close</button>
  </q-modal>   
</template>
<script>
  import {
    QBtn,
    QModal
  } from 'quasar'

  export default {
    components: {
      QBtn,
      QModal
    },
    methods: {
      open () {
        this.$refs.basicModal.open()
      }
    }
  }
</script>
