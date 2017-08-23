<template>
  <q-modal ref="basicModal" class="minimized" :content-css="{minWidth: '80vw', minHeight: '80vh'}">
    <h4>Basic Modal</h4>
    <button class="primary" @click="$refs.basicModal.close()">Close</button>
  </q-modal>   
</template>
<script>
  export default {
    methods: {
      open: function () {
        this.$refs.basicModal.open()
      }
    }
  }
</script>
