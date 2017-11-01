<template>
  <q-card ref="show-summary">
    <p class="row">
      <span class="col-2">{{formattedDateOfShow}}</span>
      <span class="col-3">{{marketName}}</span>
      <span class="col-2">{{teamName}}</span>
      <span class="col-5 row">Totals:
        <span id="tx-pl-total" class="col-1">&nbsp;</span>
        <span id="tx-pp-total" class="col-2 text-center" style="border-bottom:3px solid green;">{{this.currentShow.totalPpSales}}</span>
        <span id="tx-pl-total" class="col-1 text-center">+</span>
        <span id="tx-pl-total" class="col-2 text-center" style="padding-left:10px; padding-right:10px; border-bottom:3px solid blue;">{{this.currentShow.totalPlSales}}</span>
        <span id="tx-pl-total" class="col-1 text-center">=</span>
        <span id="tx-total" class="col-2 text-center" style="padding-left:10px; padding-right:10px; border-bottom:3px double red;">{{this.currentShow.totalSales}}</span>
      </span>
    </p>
  </q-card>
</template>
<script>
  import {
    date,
    QCard,
    QCardMain
  } from 'quasar'

  export default {
    components: {
      date,
      QCard,
      QCardMain
    },

    props: ['currentShow', 'tfpData', 'currentShowId'],

    data () {
      return {
        // currentShow: { dateOfShow: '', market: '', teamName: '', totalSales: '0' }
      }
    },

    computed: {
      formattedDateOfShow () {
        if (this.currentShow.dateOfShow) return date.formatDate(this.currentShow.dateOfShow, 'YYYY-MM-DD')
      },
      marketName () {
        return this.tfpData['markets'][this.currentShow.market].name
      },
      teamName () {
        return this.tfpData['teams'][this.currentShow.teamName].name
      }
    }
  }
</script>
