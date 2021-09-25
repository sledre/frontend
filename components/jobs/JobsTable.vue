<template>
  <b-table :items="jobs" :fields="fields" sort-by="creation_time">
    <template #cell(creation_time)="row">
      {{ $moment(row.item.creation_time).format('LLL') }}
    </template>

    <template #cell(state)="row">
      <analysis-state class="ml-2" :state="row.item.state" />
    </template>

    <template #cell(tags)="row">
      <b-badge
        v-for="tag in row.item.extras_results.tags"
        :key="tag"
        variant="secondary"
        class="mr-2 shadow"
      >
        {{ tag }}
      </b-badge>
    </template>

    <template #cell(job_type)="row">
      <b-badge
        pill
        class="mr-2 shadow"
        :variant="jobTypes[row.item.job_type].color"
      >
        {{ row.item.job_type }}
      </b-badge>
    </template>

    <template #cell(job_time)="row">
      {{ row.item.job_time }}s
    </template>

    <template #cell(actions)="row">
      <b-btn
        class="mr-2"
        :disabled="!isResultAvailable(row.item)"
        size="sm"
        @click="downloadResults(row.item.id)"
      >
        Download Results
      </b-btn>

      <b-btn
        class="ml-2"
        :disabled="row.item.state !== 'DONE'"
        variant="danger"
        size="sm"
        @click="deleteJob(row.item.id)"
      >
        Delete Job
      </b-btn>
    </template>
  </b-table>
</template>

<script>
import AnalysisState from '../malwares/AnalysisState.vue'
export default {
  name: 'JobsTable',
  components: { AnalysisState },
  props: {
    jobs: { type: Array, default: () => { return [] } }
  },
  data () {
    return {
      fields: [
        {
          key: 'creation_time',
          label: 'Job submitted on',
          sortable: true,
          class: 'text-center'
        },
        {
          key: 'state',
          label: 'State',
          sortable: true,
          class: 'text-center'
        },
        {
          key: 'tags',
          label: 'Tags',
          sortable: false,
          class: 'text-center'
        },
        {
          key: 'job_type',
          label: 'Job Type',
          sortable: true,
          class: 'text-center'
        },
        {
          key: 'job_time',
          label: 'Job Time',
          sortable: true,
          class: 'text-center'
        },
        {
          key: 'actions',
          label: 'Actions',
          class: 'text-center'
        }
      ],
      jobTypes: {
        Detours: {
          color: 'secondary'
        },
        PESieve: {
          color: 'primary'
        }
      }
    }
  },
  methods: {
    downloadResults (id) {
      window.open(`/api/jobs/${id}/download_results/`)
    },
    deleteJob (id) {
      this.$api.jobs.delete(id)
    },
    isResultAvailable (job) {
      let b = job.state === 'DONE'
      if (b && job.extras_results.tags !== null && job.extras_results.tags.includes('Empty')) {
        b = false
      }
      return b
    }
  }
}
</script>

<style lang="scss" scoped>
</style>
