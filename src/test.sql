SELECT
HD_TICKET.ID,
HD_QUEUE.NAME as Queue,
HD_CATEGORY.NAME as Category,
HD_STATUS.NAME as Status,
HD_TICKET.CREATED as DateCreated,
Year(HD_TICKET.CREATED) as YearCreated,
MonthName(HD_TICKET.CREATED) as MonthCreated,
HD_TICKET.MODIFIED as DateModified,
HD_TICKET.TIME_CLOSED as DateClosed,
RESOLUTION,
ifnull(OWNER.FULL_NAME, "(Unassigned)") as Owner,
ifnull(SUBMITTER.FULL_NAME, "(Unassigned)") as Submitter,
TITLE,
SUMMARY
 FROM ORG1.HD_TICKET
left join ORG1.USER OWNER on ORG1.HD_TICKET.OWNER_ID = OWNER.ID
left join ORG1.USER SUBMITTER on ORG1.HD_TICKET.SUBMITTER_ID = SUBMITTER.ID
left join ORG1.HD_STATUS on HD_STATUS.ID = HD_TICKET.HD_STATUS_ID
left join ORG1.HD_CATEGORY on HD_CATEGORY.ID = HD_TICKET.HD_CATEGORY_ID
left join ORG1.HD_QUEUE on HD_QUEUE.ID = HD_TICKET.HD_QUEUE_ID
where HD_QUEUE.NAME = 'Service Desk'
order by DateCreated desc;