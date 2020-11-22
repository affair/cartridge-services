return {
    db = {
        box_cfg = {
            vinyl_cache  = 8 * 1024 * 1024, -- 8 MB vinyl cache in RAM
            vinyl_memory  = 8 * 1024 * 1024, -- 8 MB vinyl cache in RAM
            checkpoint_count = 6, -- def 2
            log_level = 5,
            replication_connect_quorum = 0
        },
        format = {
            customers = {
                customer_id = 1,
                name        = 2
            },
            accounts = {
                account_id  = 1,
                customer_id = 2,
                balance     = 3,
                name        = 4
            }
        }
    }
}