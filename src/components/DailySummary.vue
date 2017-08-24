<template>
  <q-card ref="show-summary">
      <p class="row">
        <span class="col-3">{{currentShow.dateOfShow}}</span>
        <span class="col-4">{{this.currentShow.market}}</span>
        <span class="col-3">{{this.currentShow.teamName}}</span>
        <span id="tx-total" class="col-2">Total: {{this.currentShow.totalSales}}</span>
      </p>
  </q-card>
</template>
<script>
  import {
    QCard,
    QCardMain
  } from 'quasar'

  export default {
    components: {
      QCard,
      QCardMain
    },
    data () {
      return {
        currentShow: { dateOfShow: 'Sep 2, 2014', market: 'Millarville', teamName: 'Team Sean', totalSales: '2000' }
      }
    }
  }
</script>
