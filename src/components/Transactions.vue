<template>
  <div v-if="page == 'transactions'">
    <div v-for="tx in tfpData.transactions" :key="tx.id" id="transactions">
      <q-card class="row" :color="transactionColor(tx)">
        <q-card inline class="col-3 text-dark" flat>
          <q-card-main>
            <div class="row">
              <span class="col-3 text-bold">Tx#</span>
              <span class="col-3" style="text-align: right;">{{'00000'+tx.id}}</span>
              <span class="col-3 text-bold">Time:</span>
              <span class="col">{{('0' + new Date(tx.txTime).getHours()).slice(-2) + ':' + ('0' + new Date(tx.txTime).getMinutes()).slice(-2)}}</span>
            </div>
            <div class="row">
              <span class="col-3 text-bold">Tx Total</span>
              <span class="col-3" style="text-align: right;">{{tx.totalNoTax.toLocaleString('en-US', { style: 'currency', currency: 'USD' })}}</span>
            </div>
            <div v-if="tx.pp_or_pl == 'pl'" class="row">
              <span class="offset-2" />
              <span class="col-1 text-bold">+</span>
              <span id="tx-tax" class="col-3" style="text-align: right;">{{tx.tax.toLocaleString('en-US', { style: 'currency', currency: 'USD' })}}</span>
            </div>
            <div v-if="tx.pp_or_pl == 'pl'" class="row">
              <span class="offset-2" />
              <span class="col-1 text-bold">=</span>
              <span id="tx-total" class="col-3" style="text-align: right;">{{tx.total.toLocaleString('en-US', { style: 'currency', currency: 'USD' })}}</span>
            </div>
            <div class="row">
              <span class="col">{{tx.pp_or_pl}}</span>
            </div>
          </q-card-main>
        </q-card>

        <q-card inline class="col-7" flat color="light">
          <q-card  class="row" v-for="item in selectedTransactionItems(tx)" v-bind:data="item" v-bind:key="item.productItemDesc" flat color="light">
            <q-card-main class="col-12">
              <div class="row">
                <span class="col-2 text-bold text-black">Product</span>
                <span class="col-10 text-black">{{item.productTypeDesc}} - {{item.productItemDesc}}</span>
              </div>
              <div class="row">
                <span class="col-2 text-bold text-black">Qty</span>
                <span class="col-1 text-black" style="text-align: right;">{{item.qty}}</span>
              </div>
              <div class="row">
                <span class="col-2 text-bold text-black">Price</span>
                <span id="tx-total" class="col-10 text-black" style="text-align: right;">{{item.price.toLocaleString('en-US', { style: 'currency', currency: 'USD' })}}</span>
              </div>
              <div v-if="tx.pp_or_pl == 'pl'" class="row">
                <span class="col-2 text-bold text-black">Tax</span>
                <span id="tx-total" class="col-10 text-black" style="text-align: right;">{{item.tax.toLocaleString('en-US', { style: 'currency', currency: 'USD' })}}</span>
              </div>
              <div class="row">
                <q-card-separator />
              </div>
            </q-card-main>
          </q-card>
        </q-card>
        <q-card inline class="col-1" flat>
          <q-btn icon="edit" color="primary" small style="width: 100%; margin-top: 10px;" @click="editTransaction(tx)">Edit</q-btn>
          <q-btn icon="delete" color="primary" small style="width: 100%; margin-top: 10px;" @click="deleteTransaction(tx)">Delete</q-btn>
        </q-card>
      </q-card>
    </div>
  </div>
</template>

<script>
  import {
    QBtn,
    QCard,
    QCardActions,
    QCardMain,
    QCardMedia,
    QCardSeparator,
    QCardTitle
  } from 'quasar'

  export default {
    components: {
      QBtn,
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
    },

    methods: {
      transactionColor (tx) {
        if (tx.pp_or_pl === 'pl') return 'blue-2'
        return 'green-2'
      },

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
      },

      editTransaction (tx) {
        this.$emit('editTransaction', [tx, this.selectedTransactionItems(tx), 'new-transactions'])
      },

      deleteTransaction (tx) {
        this.$emit('deleteTransaction', [tx])
      }
    }
  }
</script>
