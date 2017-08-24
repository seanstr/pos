<template>
  <div>
  <q-card v-if="page == 'transactions'" v-for="tx in tfpData.transactions" v-bind:currTx="tx" :key="tx.id" id="transactions">
    <div :id="'btn'+tx.id" class="card-content">
      <div class="row tx-summary-title text-italic light-paragraph item-delimiter" style="background-color: #dadada;">
        <div class="col-1">Tx#</div>
        <div class="col-2">Time</div>
        <div class="col-2">Sum</div>
        <div class="col-2">Tax</div>
        <div class="col-2">Total</div>
        <div class="col">TxType</div>
      </div>
      <div class="row tx-summary">
        <div class="col-1">{{tx.id}}</div>
        <div class="col-2">{{('0' + new Date(tx.txTime).getHours()).slice(-2) + ':' + ('0' + new Date(tx.txTime).getMinutes()).slice(-2)}}</div>
        <div class="col-2"><div class="auto">{{tx.total}}</div></div>
        <div class="col-2"><div class="auto">{{tx.tax}}</div></div>
        <div class="col-2"><div class="auto">{{tx.total + tx.tax}}</div></div>
        <div class="col">{{tx.pp_or_pl}}</div>
      </div>
      <div class="row tx-summary" />
      <q-card-separator />
      <q-card-separator />
      <q-card-separator />
      <q-card-separator />
      <q-card-separator />
      <div class="row tx-rows-title text-italic" style="background-color: #dadada;">
        <div class="offset-1"></div>
        <div class="col-2">Prd</div>
        <div class="col-4">Description</div>
        <div class="col-1">Qty</div>
        <div class="col-2">Price</div>
        <div class="col-1">Tax</div>
      </div>
      <div class="row tx-row" v-for="item in selectedTransactionItems(tx)">
        <div class="offset-1"></div>
        <div class="col-2">{{item.productTypeDesc}}</div>
        <div class="col-4">{{item.productItemDesc}}</div>
        <div class="col-1">{{item.qty}}</div>
        <div class="col-2">{{item.price}}</div>
        <div class="col-1">{{item.tax}}</div>
      </div>
    </div>
  </q-card>
  </div>
</template>
<script>
  import {
    QCard,
    QCardMain,
    QCardSeparator
  } from 'quasar'

  export default {
    components: {
      QCard,
      QCardMain,
      QCardSeparator
    },

    data () {
      return {
      }
    }
  }
</script>
