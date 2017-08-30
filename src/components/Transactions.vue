<template>
  <div>
    <div v-if="page == 'transactions'" v-for="tx in tfpData.transactions" :key="tx.id" id="transactions">
      <q-card class="row">
        <q-card inline class="col-3 text-dark" flat :color="transactionColor">
          <q-card-main>
            <div class="row">
              <span class="col-4 text-bold">Tx#</span>
              <span class="col-3">{{tx.id}}</span>
              <span class="col-1 text-bold">@</span>
              <span class="col">{{('0' + new Date(tx.txTime).getHours()).slice(-2) + ':' + ('0' + new Date(tx.txTime).getMinutes()).slice(-2)}}</span>
            </div>
            <div class="row">
              <span class="col-4 text-bold">Tx Total</span>
              <span class="col">{{tx.total}}</span>
            </div>
            <div v-if="tx.pp_or_pl == 'pl'" class="row">
              <span class="offset-3" />
              <span class="col-1 text-bold">+</span>
              <span id="tx-tax" class="col">{{tx.tax}}</span>
            </div>
            <div v-if="tx.pp_or_pl == 'pl'" class="row">
              <span class="offset-3" />
              <span class="col-1 text-bold">=</span>
              <span id="tx-total" class="col">{{tx.total + tx.tax}}</span>
            </div>
            <div class="row">
              <span class="col">{{tx.pp_or_pl}}</span>
            </div>
          </q-card-main>
        </q-card>

        <q-card inline class="col-8" flat>
          <q-card  class="row" v-for="item in selectedTransactionItems(tx)" v-bind:data="item" v-bind:key="item.productItemDesc">
            <q-card-main class="col-12">
              <div class="row">
                <span class="col-2 text-bold">Product</span>
                <span class="col-10">{{item.productTypeDesc}} - {{item.productItemDesc}}</span>
              </div>
              <div class="row">
                <span class="col-2 text-bold">Qty</span>
                <span class="col-10">{{item.qty}}</span>
              </div>
              <div class="row">
                <span class="col-2 text-bold">Price</span>
                <span id="tx-total" class="col-10">{{item.price}}</span>
              </div>
              <div v-if="tx.pp_or_pl == 'pl'" class="row">
                <span class="col-2 text-bold">Tax</span>
                <span id="tx-total" class="col-10">{{item.tax}}</span>
              </div>
              <div class="row">
                <q-card-separator />
              </div>
            </q-card-main>
          </q-card>
        </q-card>
      </q-card>
    </div>
  </div>
</template>

<script>
  import {
    QCard,
    QCardActions,
    QCardMain,
    QCardMedia,
    QCardSeparator,
    QCardTitle
  } from 'quasar'

  export default {
    components: {
      QCard,
      QCardActions,
      QCardMain,
      QCardMedia,
      QCardSeparator,
      QCardTitle
    },

    props: ['page', 'tfpData'],

    data () {
      return {
        currTx: 0
      }
    },

    computed: {
      transactionColor () {
        if (this.currTx.pp_or_pl === 'pl') return 'blue-2'
        return 'green-2'
      }
    },

    methods: {
      selectedTransactionItems (tx) {
        this.currTx = tx
        if (this.tfpData.transactions === '') return null
        let _obj = this.tfpData.transactionItems
        let _filtered = {}
        Object.keys(_obj).forEach(function (key) {
          if (_obj[key].transactionId === tx.id) {
            _filtered[key] = _obj[key]
          }
        })
        return _filtered
      }
    }
  }
</script>
